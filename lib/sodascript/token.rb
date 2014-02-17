module Sodascript
  class Token
    attr_reader :rule, :lexeme

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

    def to_s
      "#{ @rule.name }: #{ @lexeme }"
    end
  end
end
