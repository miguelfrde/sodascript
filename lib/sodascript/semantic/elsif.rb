module Sodascript

  ##
  # Elsif representation.

  class Elsif

    # Elsif's condition
    attr_reader :condition

    # Block to be executed if the condition is true
    attr_reader :block

    ##
    # Creates a new Elsif object given a condition and the block that will be
    # executed if the condition is true.

    def initialize(condition_expr, block)
      @condition = condition_expr
      @block = block
    end

    ##
    # Performs semantic analysis and code generation for an Elsif.
    # Example:
    # elsif x == 1 do
    #   y = 2
    # Will compile to
    # else if (x == 1) {
    #   [var y;]
    #   y = 2;
    # }

    def to_s
      str = "#{Indentation.get}else if (#{@condition}) {\n"
      Indentation.increment
      str << "#{@block}\n"
      Indentation.decrement
      "#{str}#{Indentation.get}}"
    end
  end
end
