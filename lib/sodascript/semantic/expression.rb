require 'set'

module Sodascript
  class Expression
    attr_reader :variables

    def initialize(variable_list, string)
      @variables = Set.new(variable_list)
      @string = string
    end

    def self.create(a, op, b)
      Expression.new(a.variables + b.variables, "#{a}#{op}#{b}")
    end

    def to_s
      @string
    end
  end
end
