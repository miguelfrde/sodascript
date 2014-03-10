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
        @non_terminals.add(sym) if sym.is_a?(Symbol) && sym != :epsilon
      end
      @non_terminals.add(lhs)
    end
  end
end
