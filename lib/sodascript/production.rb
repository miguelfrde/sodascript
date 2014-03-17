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

    ##
    # Creates a new production.
    # The left hand side must be a symbol and the right hand side must have
    # at least one Symbol (non-terminal) or one Rule (terminal)

    def initialize(lhs, *args)
      raise ArgumentError, 'You should at least provide one rhs symbol' unless
        args.size > 0
      raise ArgumentError, 'Left-hand side must be a symbol' unless
        lhs.is_a?(Symbol) && lhs != Grammar::EPSILON
      args.each do |s|
        raise ArgumentError, 'Right-hand side symbols must be TokenRules or Symbols' unless
          s.is_a?(Rule) || s.is_a?(Symbol)
      end
      @lhs = lhs
      @rhs = args.map { |s| (s.is_a?(Rule) && s.name) || s }
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
      "#{@lhs} -> #{@rhs.join(' ')}"
    end

  end
end
