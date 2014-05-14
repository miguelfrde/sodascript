module Sodascript

  ##
  # When representation

  class When

    # When expression to be evaluated
    attr_reader :expression

    # Block that is evaluated if the expression is true
    attr_reader :block

    ##
    # Creates a new When object given a expression and the block that will be
    # executed if the expression is true

    def initialize(expression, block)
      @expression = expression
      @block = block
    end

    ##
    # Performs semantic analysis and code generation for a when statement.
    # Refer to Sodascript::Case for an example

    def to_s
      str = "#{Indentation.get}case #{@expression}:\n"
      Indentation.indent { str << "#{block}\n#{Indentation.get}break;" }
      str
    end
  end
end
