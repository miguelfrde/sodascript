require 'sodascript/slritem'
require 'sodascript/slrtable'
require 'sodascript/grammar'

module Sodascript

  ##
  # This class creates an SLR table that then uses to parse strings using the
  # LR parsing algorithm

  class SLRParser

    ##
    # Creates the parser and the table it will use to parse from a given grammar

    def initialize(grammar)
      @prod_list = grammar.productions.values.flatten
      grammar.add_production(:Sprime, grammar.start_symbol)
      @prod_list = [grammar.productions[:Sprime][0]] + @prod_list

      @prod_hash = {}
      @prod_list.each_with_index { |prod, index| @prod_hash[prod.to_s] = index }

      @table = SLRTable.new(
          grammar.terminals.keys | [Grammar::END_SYM],
          grammar.non_terminals - [:Sprime]
      )
      build_table(grammar)

      if ENV['SODA_DEBUG']
        puts "Productions:"
        @prod_list.each_with_index { |prod, i| puts "  #{i}   #{prod}" }
        puts "SLR Table:"
        puts @table
      end
    end

    ##
    # Run the LR parsing algorithm over a set of tokens

    def parse(tokens)
      @tokens = tokens
      @input = @tokens.next
      @symbols = Array.new
      @stack = [ 0 ]
      success = true
      @line = 1
      while true
        begin
        s = @stack[-1]
        a, t = @table.action(s, @input.rule.name)
        if a == SLRTable::SHIFT
          @stack.push(t)
          @input = @tokens.next
          @line += 1 if @input.rule.name == :br
        elsif a == SLRTable::REDUCE
          production = @prod_list[t]
          @stack.pop(production.cardinality)
          t = @stack[-1]
          @stack.push(@table.goto(t, production.lhs))
        elsif a == SLRTable::ACCEPT
          break
        else
          # Call error
          success = false
          SodaLogger.error("unexpected token #{@input} in line #{@line}")
          error_handler()
          if @unable_to_recover_anymore
            break
          end
        end
        rescue StopIteration
          SodaLogger.fail('unexpected exhaustion of tokens input')
        end
      end

      SodaLogger.fail('errors were found while parsing',
                      !ENV['SODA_DEBUG'].nil?) unless success
    end

    private

    ##
    # Handles parsing errors

    def error_handler()
      @stack.reverse_each do |i|
        unless @table.goto_table[i].nil?
          non_terminal, state = @table.goto_table[i].first
          while true
            unless @table.action(state, @input.rule.name).nil?
              @stack.push(state) #push state Ik
              @symbols.push(non_terminal)
              break
            else
              begin
              @input = @tokens.next
              @line += 1 if  @input.rule.name == :br
              rescue StopIteration  #This happens when the only token left is END_SYMBOL, there's nothing else to do.
                @unable_to_recover_anymore = true
                return
              end
            end
          end
          break
        end
        @stack.pop
        @symbols.pop

        begin
        @input = @tokens.next
        @line += 1 if @input.rule.name == :br
        rescue StopIteration  #This COULD happen when the only token left is END_SYMBOL, there's nothing else to do.
          @unable_to_recover_anymore = true
        end
      end
    end



    ##
    # Builds the SLR table used by parse() to parse a list of tokens.
    # While computing the list of items that are used to generate the SLR table,
    # it fills the table with the correspoding shift and reduce actions.

    def build_table(grammar)
      initial_item = SLRItem.new([grammar.productions[:Sprime][0]], [0])
      items = [initial_item.closure(grammar)]
      symbols = grammar.non_terminals | grammar.terminals.keys

      items.each_with_index do |item, from_index|
        symbols.each do |symbol|
          goto_item = item.goto(symbol, grammar)
          next if goto_item.empty?
          add_shifts(from_index, goto_item, symbol, items)
          add_reduces(goto_item, items.index(goto_item), grammar)
        end
      end

      add_reduces(items[0], 0, grammar)

      if ENV['SODA_DEBUG']
        puts "Items:"
        items.each_with_index do |item, i|
          puts " #{i}   #{item.productions.map{ |p| p.to_s }} #{item.positions}"
        end
      end
    end

    ##
    # Adds a shift action from the item in 'from_index' to the goto_item with
    # the provided symbol and saves the new goto_item if it's new.

    def add_shifts(from_index, goto_item, symbol, items)
      unless (to_index = items.index(goto_item)).nil?
        # Item already existed, add shift with the new symbol
        @table.shift(from_index, symbol, to_index)
        return
      end
      # New item, add shift
      @table.shift(from_index, symbol, items.size)
      items << goto_item
    end

    ##
    # Finds all reduce actions that the item contains.

    def add_reduces(item, item_index, grammar)
      item.each_production do |production, pos|
        next unless production.rhs.size == pos
        if production.lhs == :Sprime
          @table.accept(item_index, Grammar::END_SYM)
        else
          grammar.follow_set(production.lhs).each do |symbol|
            @table.reduce(item_index, symbol, @prod_hash[production.to_s])
          end
        end
      end
    end

  end
end
