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
      @input = tokens
      @symbols = Array.new
      @stack = [ 0 ]
      @input.push(Sodascript::Token.new(Sodascript::Rule.new(Grammar::END_SYM, /^\$$/), "$"))
      @bc = 0
      success = true
      rows = []
      rows << ["#{@stack.join(" ")}", " ", @input[@bc..-1].map {|x| x.rule.name}]
      @line = 1
      while @bc < @input.size
        s = @stack[-1]
        a, t = @table.action(s, @input[@bc].rule.name)
        if a == SLRTable::SHIFT
          @stack.push(t)
          @bc += 1
          @line += 1 if @bc < @input.size && @input[@bc].rule.name == :br
        elsif a == SLRTable::REDUCE
          production = @prod_list[t]
          @stack.pop(production.cardinality)
          t = @stack[-1]
          @stack.push(@table.goto(t, production.lhs))
        elsif a == SLRTable::ACCEPT
          if ENV['SODA_DEBUG']
            rows << ["#{@stack.join(" ")}", @symbols.to_s, @input[@bc..-1].map {|x| x.rule.name}, "Accept"]
          end
          break
        else
          # Call error
          success = false
          SodaLogger.error("unexpected token #{@input[@bc]} in line #{@line}")
          if ENV['SODA_DEBUG']
            rows << ["#{@stack.join(" ")}", @symbols.to_s, @input[@bc..-1].map {|x| x.rule.name}, "Error unexpected #{@input[@bc]}"]
          end
          error_handler()
        end


        if ENV['SODA_DEBUG']
          if a == SLRTable::SHIFT
            @symbols.push(@input[@bc-1].rule.name)
            rows << ["#{@stack.join(" ")}", @symbols.to_s, @input[@bc..-1].map {|x| x.rule.name}, "Shift"]
          elsif a == SLRTable::REDUCE
            @symbols.pop(production.cardinality)
            @symbols.push(production.lhs)
            rows << ["#{@stack.join(" ")}", @symbols.to_s, @input[@bc..-1].map {|x| x.rule.name}, "Reduce by #{production}"]
          end

        end
      end

      if ENV['SODA_DEBUG']
        table = Terminal::Table.new :headings => ['Stack', 'Symbols', 'Input', 'Action'], :rows => rows
        puts table
      end

      SodaLogger.fail("errors were found while parsing",
        !ENV['SODA_DEBUG'].nil?) unless success
    end

    private

    ##
    # Handles parsing errors

    def error_handler()
      @stack.reverse_each do |i|
        unless @table.goto_table[i].nil?
          #iterar hasta que con la entrada me pueda ir a otro lado
          non_terminal, state = @table.goto_table[i].first
          while @bc < @input.size
            unless @table.action(state, @input[@bc].rule.name).nil?
              @stack.push(state) #push state Ik
              @symbols.push(non_terminal)
              break
            else
              @bc += 1 #Discard all symbols from the input till s'
              @line += 1 if @bc < @input.size && @input[@bc].rule.name == :br
            end
          end
          break
        end
        @stack.pop
        @symbols.pop
        @bc += 1
        @line += 1 if @bc < @input.size && @input[@bc].rule.name == :br
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
