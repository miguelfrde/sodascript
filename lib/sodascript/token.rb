module Sodascript

  ##
  # Token is used by Lexer to keep track of all the tokens it finds in the file.

  class Token

    # Token associated rule (Rule)
    attr_reader :rule

    # Token's lexeme (String)
    attr_reader :lexeme

    ##
    # Creates a token given a _rule_ (Rule) and a _lexeme_ (String).

    def initialize(rule, lexeme)
      raise ArgumentError, 'rule must be a Rule' unless
        rule.is_a?(Rule)
      raise ArgumentError, 'lexeme must be a String' unless
        lexeme.is_a?(String)
      raise ArgumentError, 'rule must match lexeme' unless
        rule.matches?(lexeme)
      @rule = rule
      @lexeme = lexeme
    end

    ##
    # String representation of a token

    def to_s
      "#{ @rule.name }: #{ @lexeme.inspect[1..-2] }"
    end
  end
end
