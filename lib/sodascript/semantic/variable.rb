require 'set'

module Sodascript
  class Variable
    attr_reader :name, :variables, :string

    def initialize(name, string, variable_list, inline = false)
      @name = name
      @string = string
      @variables = Set.new(variable_list)
      @variables << name
      @inline = inline
    end

    def to_s
      Semantic.assert_exists(*variables)
      return "#{Indentation.get}#{@string};" if @inline
      @string
    end

    def complex?
      @string.include?('.')
    end

    def self?
      @name == 'self'
    end
  end
end
