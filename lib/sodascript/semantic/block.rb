module Sodascript

  ##
  # Consists of a list of all the structures that form the program and other
  # blocks like the block inside a while, for, if, etc.

  class Block

    # List of program structures
    attr_reader :block

    ##
    # Creates a block, given a list of program structures (if, while, for,
    # assign, function, range, unless, case, etc.

    def initialize(expr_list)
      @block = expr_list
      @variables_to_define = []
    end

    ##
    # True if the block has nothing inside it

    def empty?
      @block.empty?
    end

    ##
    # Performs semantic analysis and code generation for a block.
    # For semantic analysis, this just creates a new scope inside the Semantic
    # class. For more information refer to the Semantic class.

    def to_s
      Semantic.push_new_block
      result = @block.map(&:to_s).join("\n")
      Semantic.pop_block
      result
    end
  end
end
