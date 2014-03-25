require 'sodascript/grammar'

module Sodascript

  ##
  # Representation of an item used to build the SLR parsing table or the LR(0)
  # automaton. In the LR(0) automaton, each item represents a state. Stores
  # a list of the productions that belong to the Item set and the positions of
  # the '.' on each production.

  class SLRItem

    # Productions that belong to the Item set.
    attr_reader :productions

    # Position of the '.' for the respective production. ith position for the
    # ith production.
    attr_reader :positions

    ##
    # Create a new item providing the productions and the positions of the dot
    # for each production. Position[i] belongs to Production[i].

    def initialize(productions, positions)
      raise ArgumentError, "Positions size must be the same as Productions size" unless
        productions.size == positions.size
      @productions = productions
      @positions = positions
    end

    ##
    # Compute the closure of an Item

    def closure(grammar)
      result_productions = @productions.clone
      result_positions = @positions.clone

      result_productions.each_with_index do |production, index|
        pos = result_positions[index]
        # Case A -> B.
        next if pos == production.rhs.size
        # Case A -> a.b where b is a terminal
        next unless grammar.non_terminals.include?(production.rhs[pos])

        grammar.productions[production.rhs[pos]].each do |prod|
          index = result_productions.index(prod)
          next if index && result_positions[index] == 0 # Production exists
          result_productions << prod
          result_positions << 0
        end
      end
      SLRItem.new(result_productions, result_positions)
    end

    ##
    # For each production A -> a.Bb if B == symbol, substitute it by A -> aB.b
    # and compute the closure of the new set of productions

    def goto(symbol, grammar)
      result_productions = []
      result_positions = []
      @productions.each_with_index do |production, i|
        pos = @positions[i]
        if production.rhs[pos] == symbol
          result_productions << production
          result_positions << pos + 1
        end
      end
      SLRItem.new(result_productions, result_positions).closure(grammar)
    end

    ##
    # True if all elements are nil, false otherwise

    def empty?
      @productions.size == 0
    end

    ##
    # True if all elements are equal, false otherwise

    def ==(other)
      equal_productions = Set.new(@productions) == Set.new(other.productions)
      return false unless equal_productions
      hash_list = lambda do |item|
        item.productions.each_with_index.map{ |p, i| [p, item.positions[i]] }
      end
      hash1 = Hash[hash_list.call(self)]
      hash2 = Hash[hash_list.call(other)]
      hash1.all? { |prod, pos| pos == hash2[prod] }
    end

    ##
    # Iterate over all productions of an item. Returns the production and the
    # position where the dot is

    def each_production
      return to_enum(:each_production) unless block_given?
      @productions.each_with_index { |prod, i| yield prod, @positions[i] }
    end

  end
end
