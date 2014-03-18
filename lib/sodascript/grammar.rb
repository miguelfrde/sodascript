require 'set'
require 'sodascript/production'

module Sodascript

  ##
  # Representation of a Grammar. Contains methods to obtain First sets, Follow
  # sets and a logical representation of a grammar using hashes and sets.

  class Grammar

    # Epsilon representation
    EPSILON = :epsilon

    # $ representation
    END_SYM = :"$"

    # Maps a non-terminal to all its associated productions
    # Ex: {:A => [bA, c]}
    attr_reader :productions

    # List of all non-terminals
    attr_reader :non_terminals

    # Start symbol S of the grammar
    attr_reader :start_symbol

    # List of all terminals
    attr_reader :terminals

    def initialize(start_symbol)
      raise ArgumentError, 'start_symbol must be a symbol' unless
        start_symbol.is_a?(Symbol)
      @productions = {} # Maps a non-terminal A to all B, s.t. A -> B 
      @non_terminals = Set.new([start_symbol])
      @terminals = {} # Maps a terminal name to its rule
      @start_symbol = start_symbol
      @first = {} # Cache first(X)
      @follow = {} # Cache follow(X)
    end

    ##
    # Adds a new production to the grammar
    # :args: left-hand side symbol, right-hand side symbols

    def add_production(lhs, *args)
      (@productions[lhs] ||= []) << Production.new(lhs, *args)
      args.each do |sym|
        @terminals[sym.name] = sym if sym.is_a?(Rule)
        @non_terminals << sym if sym.is_a?(Symbol) && sym != EPSILON
      end
      @non_terminals << lhs
    end

    ##
    # Compute First(X1, X2, ..., Xn) where each X is a non-terminal or a
    # terminal

    def first_set(*symbols)
      raise ArgumentError, 'You should provide at least one symbol' unless
        symbols.size > 0
      if symbols.size == 1
        _first_set(symbols[0], Set.new([symbols[0]]))
      else
        first_symbols_iterator(symbols, [])
      end
    end

    ##
    # Compute Follow(Symbol), where symbol can be either a terminal or a
    # non-terminal

    def follow_set(symbol)
      def _follow_set(symbol, explored)
        raise ArgumentError, 'Symbol is not defined' unless
          non_terminals.include?(symbol)

        return @follow[symbol] if @follow.has_key?(symbol)

        @follow[symbol] = Set.new
        @follow[symbol] << END_SYM if symbol == @start_symbol

        @productions.each do |_, prods|
          prods.each do |prod|
            prod.rhs.each_with_index do |sym, i|
              # In this case X = symbol
              next if sym != symbol

              # If A -> aX, then everything in Follow(A) is in Follow(X)
              if i == prod.rhs.size - 1
                @follow[symbol] |= _follow_set(prod.lhs, explored | [prod.lhs]) unless
                  explored.include?(prod.lhs)
                next
              end

              # If A -> aXb, then everything in First(b) - {epsilon} is in
              # Follow(X)
              first_b = first_set(*prod.rhs[i+1..-1])
              @follow[symbol] |=  first_b - [EPSILON]

              # If A -> aBb and epsilon in First(b), then everything in
              # Follow(A) is in Follow(X)
              if first_b.include?(EPSILON)
                @follow[symbol] |= _follow_set(prod.lhs, explored | [prod.lhs]) unless
                  explored.include?(prod.lhs)
              end
            end
          end
        end
        @follow[symbol]
      end
      _follow_set(symbol, Set.new([symbol]))
    end

    ##
    # String representation of the grammar

    def to_s
      t = @terminals.map{ |term, rule| rule.to_s }.join("\n")
      prods_str = ->(ps) { ps.map{ |p| p.rhs.join(" ") }.join(" | ") }
      p = @productions.map{ |n, ps| "#{n} -> " + prods_str.call(ps) }.join("\n")
      "#{t}\n#{p}"
    end

    private

    ##
    # Computes First(symbol), uses explored to keep track of symbols already
    # visited to avoid falling into an infinite recursion

    def _first_set(symbol, explored)
      # First(terminal) = {terminal}
      return Set.new([symbol]) if
        terminals.has_key?(symbol) || symbol == EPSILON

      return @first[symbol] if @first.has_key?(symbol)

      raise ArgumentError, 'Symbol is not defined' unless
        non_terminals.include?(symbol)

      result = Set.new
      productions[symbol].each do |prod|
        result |= first_symbols_iterator(prod.rhs, explored)
      end
      @first[symbol] = result
      result
    end

    ##
    # Computes First(X1, X2, ..., Xn), where each X is a non-terminal or a
    # terminal uses explored to keep track of symbols already visited to avoid
    # falling into an infinite recursion

    def first_symbols_iterator(symbol_list, explored)
      result = Set.new
      eps = 0
      # X is a non-terminal (prod.rhs). X -> Y1Y2...Yn
      # If epsilon in First(Y1...Yi-1), then all a in First(Yi) is in First(X)
      symbol_list.each do |sym|
        first = _first_set(sym, explored | [sym])
        result |= first - [EPSILON]
        break unless first.include?(EPSILON)
        eps += 1
      end
      # If epsilon in First(Y1...Yn) then epsilon in First(X)
      result << EPSILON if eps == symbol_list.size
      result
    end
  end
end
