module Sodascript

  ##
  # Return representation

  class Return

    # Expression to be returned (optinoal)
    attr_reader :expression

    ##
    # Create a new return statement given a expression. If the expression is
    # nil, nothing will be returned.

    def initialize(expr = nil)
      @expression = expr
    end

    ##
    # Semantic analysis and code generation for the return expression.

    def to_s
      unless Semantic.in_function
        SodaLogger.error('return can only be used inside a function definition')
      end
      "#{Indentation.get}return #{@expression};"
    end
  end
end
