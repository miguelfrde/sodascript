module Sodascript

  ##
  # While representation

  class While

    # While condition
    attr_reader :condition

    # Block that is evaluated while the condition remains satisfied
    attr_reader :block

    ##
    # Creates a new While given its condition and block.

    def initialize(condition_expr, block)
      @condition = condition_expr
      @block = block
    end

    ##
    # Perform semantic analysis and code generation for the while statement.
    # For more information refer to Sodascript::Semantic.check_loop

    def to_s
      Semantic.check_loop do
        str = "#{Indentation.get}while (#{@condition}) {\n"
        Indentation.indent { str << "#{@block}\n" }
        "#{str}#{Indentation.get}}\n"
      end
    end
  end
end
