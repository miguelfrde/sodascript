require 'set'

module Sodascript
  class Variable
    attr_reader :name, :variables

    def initialize(name, string, variable_list)
      @name = name
      @string = string
      @variables = Set.new(variable_list)
      @variables << name
    end

    def to_s
      @string
    end
  end
end
