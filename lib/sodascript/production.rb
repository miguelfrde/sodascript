require 'sodascript/rule'
require 'sodascript/grammar'

module Sodascript

  ##
  # Stores a grammar production like A -> bC

  class Production

    # Left hand side of the production
    attr_reader :lhs

    # Rule's regular expression (Regexp)
    attr_reader :rhs

    # Production's semantic action
    attr_reader :action

    ##
    # Creates a new production.
    # The left hand side must be a symbol and the right hand side must have
    # at least one Symbol (non-terminal) or one Rule (terminal)

    def initialize(lhs, action, *symbols)
      raise ArgumentError, 'You should at least provide one rhs symbol' unless
        symbols.size > 0
      raise ArgumentError, 'Left-hand side must be a symbol' unless
        lhs.is_a?(Symbol) && lhs != Grammar::EPSILON
      raise ArgumentError, 'Action must be a String' unless
        action.is_a?(String)
      symbol_error = 'Right-hand side symbols must be TokenRules or Symbols'
      symbols.each do |s|
        raise ArgumentError, symbol_error unless
          s.is_a?(Rule) || s.is_a?(Symbol)
      end
      @lhs = lhs
      @action = action
      @rhs = symbols.map { |s| (s.is_a?(Rule) && s.name) || s }
      @rhs.select! { |s| s != Grammar::EPSILON }
    end

    ##
    # Returns the cardinality of the production
    def cardinality
      @rhs.size
    end

    ##
    # Compares two productions. Returns true if lhs = other.lhs and
    # rhs = other.rhs, false otherwise.

    def ==(other)
      @lhs == other.lhs && @rhs == other.rhs
    end

    ##
    # String representation of the production

    def to_s
      "#{@lhs} -> #{rhs_str}"
    end

    ##
    # String representation of the right-hand side of the production

    def rhs_str
      rhs = if @rhs.size > 0 then @rhs else [Grammar::EPSILON] end
      "#{rhs.join(' ')}"
    end

  end
end
