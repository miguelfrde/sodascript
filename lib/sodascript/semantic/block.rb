module Sodascript
  class Block
    attr_reader :block

    def initialize(expr_list)
      @block = expr_list
      @variables_to_define = []
    end

    def empty?
      @block.empty?
    end

    def to_s
      Semantic.push_new_block
      result = @block.map(&:to_s).join("\n")
      Semantic.pop_block
      result
    end
  end
end
