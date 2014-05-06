require 'set'

module Sodascript
  class Variable
    attr_reader :name, :variables

    def initialize(name, string, variable_list, inline = false)
      @name = name
      @string = string
      @variables = Set.new(variable_list)
      @variables << name
      @inline = inline
    end

    def to_s
      return "#{Indentation.get}#{@string}" if @inline
      @string
    end
  end
end
