module Sodascript

  ##
  # Print representation

  class Print

    # Expression that the print statement prints
    attr_reader :expression

    ##
    # Creates a new print statement given the expression that it will print

    def initialize(expr)
      @expression = expr
    end

    ##
    # Performs semantic analysis and code generation for the expression.
    # Example:
    # print "hello" -> console.log("hello");

    def to_s
      "#{Indentation.get}console.log(#{@expression});"
    end
  end
end
