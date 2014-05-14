module Sodascript

  ##
  # Unless representation

  class Unless

    # TODO: this method should only contain an if, it's nothing more but an if
    # that can't have elsifs and that has the conditon negated.

    # Unless condition
    attr_reader :condition

    # Block to be executed if the condition is true
    attr_reader :unless_block

    # Block to be executed if the condition is false
    attr_reader :else_block

    ##
    # Creates a new unless object given a condition a true block and a false
    # block

    def initialize(condition_expr, unless_block, else_block)
      @condition = condition_expr
      @unless_block = unless_block
      @else_block = else_block
    end

    ##
    # Performs semantic analysis and code generation for the unless statement
    # This just generates and if with the condition negated.

    def to_s
      indent = Indentation.get
      str = "#{indent}if (!(#{@condition})) {\n"
      Indentation.indent { str << "#{@unless_block}\n" }
      str << "#{indent}}\n"
      str << "#{indent}else {\n"
      Indentation.indent do
        str << "#{@else_block}\n#{indent}}\n" unless else_block.empty?
      end
      str
    end
  end
end
