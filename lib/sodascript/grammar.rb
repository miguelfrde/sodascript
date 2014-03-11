require 'set'
require 'sodascript/rule'

module Sodascript

  ##
  # Stores a grammar production like A -> bC

  class Production

    # Left hand side of the production
    attr_reader :lhs

    # Rule's regular expression (Regexp)
    attr_reader :rhs

    ##
    # Creates a new production.
    # The left hand side must be a symbol and the right hand side must have
    # at least one Symbol (non-terminal) or one Rule (terminal)

    def initialize(lhs, *args)
      raise ArgumentError, 'You should at least provide one rhs symbol' unless
        args.size > 0
      raise ArgumentError, 'Left-hand side must be a symbol' unless
        lhs.is_a?(Symbol) && lhs != :epsilon
      args.each do |s|
        raise ArgumentError, 'Right-hand side symbols must be TokenRules or Symbols' unless
          s.is_a?(Rule) || s.is_a?(Symbol)
      end
      @lhs = lhs
      @rhs = args.map { |s| (s.is_a?(Rule) && s.name) || s }
    end

  end


  class Grammar

    # Maps a non-terminal to all its associated productions
    # Ex: {:A => [bA, c]}
    attr_reader :productions

    # List of all non-terminals
    attr_reader :non_terminals

    # Start symbol S of the grammar
    attr_reader :start_symbol

    # List of all terminals
    attr_reader :terminals

    ##
    # Get our epsilon symbol representation

    def self.epsilon
      :epsilon
    end

    ##
    # Get our $ symbol representation

    def self.end
      :"$"
    end

    def initialize(start_symbol)
      raise ArgumentError, 'start_symbol must be a symbol' unless
        start_symbol.is_a?(Symbol)
      @productions = {} # Maps a non-terminal A to all B, s.t. A -> B 
      @non_terminals = Set.new
      @terminals = {} # Maps a terminal name to its rule
      @start_symbol = start_symbol
    end

    ##
    # Adds a new production to the grammar
    # :args: left-hand side symbol, right-hand side symbols

    def add_production(lhs, *args)
      (@productions[lhs] ||= []) << Production.new(lhs, *args)
      args.each do |sym|
        @terminals[sym.name] = sym if sym.is_a?(Rule)
        @non_terminals << sym if sym.is_a?(Symbol) && sym != :epsilon
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

        result = Set.new
        result << self.class.end if symbol == @start_symbol

        @productions.each do |_, prods|
          prods.each do |prod|
            prod.rhs.each_with_index do |sym, i|
              # In this case X = symbol
              next if sym != symbol

              # If A -> aX, then everything in Follow(A) is in Follow(X)
              if i == prod.rhs.size - 1
                result |= _follow_set(prod.lhs, explored | [prod.lhs]) unless
                  explored.include?(prod.lhs)
                next
              end

              # If A -> aXb, then everything in First(b) - {epsilon} is in
              # Follow(X)
              first_b = first_set(*prod.rhs[i+1..-1])
              result |=  first_b - [self.class.epsilon]

              # If A -> aBb and epsilon in First(b), then everything in
              # Follow(A) is in Follow(X)
              if first_b.include?(self.class.epsilon)
                result |= _follow_set(prod.lhs, explored | [prod.lhs]) unless
                  explored.include?(prod.lhs)
              end
            end
          end
        end
        result
      end
      _follow_set(symbol, Set.new([symbol]))
    end

    private

    ##
    # Computes First(symbol), uses explored to keep track of symbols already
    # visited to avoid falling into an infinite recursion

    def _first_set(symbol, explored)
      return Set.new([symbol]) if
        terminals.has_key?(symbol) || symbol == self.class.epsilon

      raise ArgumentError, 'Symbol is not defined' unless
        non_terminals.include?(symbol)

      result = Set.new
      productions[symbol].each do |prod|
        result |= first_symbols_iterator(prod.rhs, explored)
      end
      result
    end

    ##
    # Computes First(X1, X2, ..., Xn), where each X is a non-terminal or a
    # terminal uses explored to keep track of symbols already visited to avoid
    # falling into an infinite recursion

    def first_symbols_iterator(symbol_list, explored)
      result = Set.new
      eps = 0
      symbol_list.each do |sym|
        # If X is a terminal => First(X) = {X}
        first = _first_set(sym, explored | [sym])
        result |= first - [self.class.epsilon]
        break unless first.include?(self.class.epsilon)
        eps += 1
      end
      result << self.class.epsilon if eps == symbol_list.size
      result
    end
  end
end
