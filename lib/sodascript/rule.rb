module Sodascript
  class Rule
    attr_reader :name, :regex

    def initialize(name, regex)
      raise ArgumentError, 'name must be a Symbol' unless
        name.is_a?(Symbol)
      raise ArgumentError, 'regex must be a Regexp' unless
        regex.is_a?(Regexp)
      @name = name
      @regex = regex
    end

    def matches?(string)
      string =~ @regex
    end
  end
end
