module Sodascript

  ##
  # Rule is used by Lexer to keep track of the defined rules.
  # It consists of a name (Symbol) and a regular expression.

  class Rule

    # Rule's name (Symbol)
    attr_reader :name

    # Rule's regular expression (Regexp)
    attr_reader :regex

    ##
    # Create a new token rule with a given symbol as a name
    # and a regular expression that will be used to match this rule

    def initialize(name, regex)
      raise ArgumentError, 'name must be a Symbol' unless
        name.is_a?(Symbol)
      raise ArgumentError, 'regex must be a Regexp' unless
        regex.is_a?(Regexp)
      @name = name
      @regex = regex
    end

    ##
    # Checks if the string matches the regular expression associated with
    # the Rule.

    def matches?(string)
      string =~ @regex
    end

    ##
    # Returns the string representation of a Rule
    def to_s
      "#{@name} -> #{@regex.to_s[8..-3]}"
    end
  end
end
