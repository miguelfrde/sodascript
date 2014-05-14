require 'set'

module Sodascript

  ##
  # Variable representation

  class Variable

    # Name of the variable (can contain dots, for example: obj.attr,
    # obj.method())
    attr_reader :name

    # Variables that the variable contains. Relvante for variables like
    # obj.method(a, b). In that example, variables = [a, b]
    attr_reader :variables

    # String representation of the variable
    attr_reader :string

    ##
    # Creates a new variable given its name, string representation, variable
    # list and sepecifying if it's inline or not. Inline means that the variable
    # is not inside an assign, expression, etc. It's just: obj.method() for
    # example.

    def initialize(name, string, variable_list, inline = false)
      @name = name
      @string = string
      @variables = Set.new(variable_list)
      @variables << name
      @inline = inline
    end

    ##
    # Perform semantic analysis and code generation for the variable. Checks if
    # all variables are defined and returns the string representation, ending
    # with ';' if it's inline.

    def to_s
      Semantic.assert_exists(*variables)
      return "#{Indentation.get}#{@string};" if @inline
      @string
    end

    ##
    # True if the string contains a dot

    def complex?
      @string.include?('.')
    end

    ##
    # True if the variable name is self

    def self?
      @name == 'self'
    end
  end
end
