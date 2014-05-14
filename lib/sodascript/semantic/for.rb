module Sodascript

  ##
  # For respresentation

  class For

    # Variable that will contain the current item from the iterable
    attr_reader :var

    # Iterable expression.
    attr_reader :iterable

    # Block to be executed with each item from the iterable.
    attr_reader :block

    ##
    # Create a new For given the varaible, the iterable and the block.

    def initialize(var, iterable, block)
      @var = var
      @iterable = iterable
      @block = block
    end

    ##
    # Perform code generation and semantic analysis for the For. For more
    # information refer to Sodascript::Semantic.check_loop

    def to_s
      Semantic.check_loop do
        Semantic.push_new_block(@var.name)
        str = "#{Indentation.get}#{@iterable}.forEach(function(#{@var}) {\n"
        Indentation.indent { str << "#{@block}\n" }
        Semantic.pop_block
        "#{str}#{Indentation.get}});"
      end
    end
  end
end
