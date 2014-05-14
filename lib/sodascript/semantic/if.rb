module Sodascript

  ##
  # If representation

  class If

    # If condition
    attr_reader :condition

    # Block to be executed if the condition is true
    attr_reader :if_block

    # List of elsifs
    attr_reader :elsifs

    # Block to be executed if the condition is false and none of the elsifs is
    # executed
    attr_reader :else_block

    ##
    # Creates a new if from a given condition, true block, list of elsifs and
    # false block

    def initialize(condition_expr, if_block, elsifs, else_block)
      @condition = condition_expr
      @if_block = if_block
      @elsifs = elsifs
      @else_block = else_block
    end

    ##
    # Perform semantic analysis and code generation for the if statement.

    def to_s
      indent = Indentation.get
      str = "#{indent}if (#{@condition}) {\n"
      Indentation.indent { str << "#{@if_block}\n" }
      str << "#{indent}}\n"
      str << "#{@elsifs}\n" unless @elsifs.empty?
      unless @else_block.empty?
        Indentation.indent do
          str << "#{indent}else {\n#{@else_block}\n#{indent}}"
        end
      end
      str
    end
  end
end
