require 'sodascript/grammar'
require 'terminal-table'

module Sodascript

  ##
  # Top-down parsing implementation, LL(1) algorithm

  class LLParser

    # Stores the LL(1) parsing table as a hash of hashes
    attr_reader :table

    ##
    # Initialize a new LL(1) parser from a given grammar

    def initialize(grammar)
      @grammar = grammar
      do_table
      puts "\nLL1 Table:\n" + table_to_s if ENV['SODA_DEBUG']
    end

    ##
    # String representation of the parsing table

    def table_to_s
      table = Terminal::Table.new do |t|
        symbols = @grammar.terminals.keys.to_a + [Grammar::END_SYM]
        t << [''] + symbols

        @grammar.non_terminals.each do |non_terminal|
          t.add_separator
          row = [non_terminal]
          symbols.each { |sym| row << @table[non_terminal][sym].to_s || ' '}
          t << row
        end

      end
      table.to_s
    end


    ##
    # Perform LL(1) top-down parsing algorithm on a set of tokens

    def parse(tokens)
      input = []
      tokens.map { |e| input << e.rule.name }
      input << Grammar::END_SYM
      stack = [ Grammar::END_SYM, @grammar.start_symbol ]
      table = Terminal::Table.new do |t|
        t << ['Input', 'Stack', 'Action']
        t.add_separator
        row = [input.join(' '),  stack.reverse.join(' ')]
        while stack[-1] != Grammar::END_SYM
          if stack[-1] == input[0]
            row << stack.pop.to_s
            input.shift
          elsif @grammar.terminals.include?(stack[-1])
            SodaLogger.fail("Parsing error, tried to pop the terminal #{stack[-1]}")
          elsif @table[stack[-1]][input[0]].nil?
            SodaLogger.fail("Parsing error, unexpected token #{input[0]}")
          else
            aux = stack.pop
            @table[aux][input[0]].rhs.reverse_each { |sym| stack << sym }
            row << @table[aux][input[0]].to_s
          end
          t << row
          row = [input.join(' '),  stack.reverse.join(' ')]
        end
        t << [input.join(' '),  stack.join(' '), '']
      end
      puts "Parse Table:\n" + table.to_s if ENV['SODA_DEBUG']
    end

    private

    ##
    # Create a new LL(1) parsing table from the given grammar

    def do_table
      @table = Hash.new { |h,k| h[k] = Hash.new }

      @grammar.productions.each do |lhs, prods|
        prods.each do |prod|
          if prod.rhs.size > 0
            i = 0
            sub_first = @grammar.first_set(prod.rhs[0])
            while sub_first.include?(Grammar::EPSILON)
              sub_first -= [Grammar::EPSILON]
              i += 1
              sub_first += @grammar.first_set(prod.rhs[i])
            end

            sub_first.each { |sym| table[lhs][sym] = prod }

          else
            @grammar.follow_set(lhs).each { |sym| table[lhs][sym] = prod }
          end
        end
      end
    end

  end
end
