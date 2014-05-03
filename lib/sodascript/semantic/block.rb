module Sodascript
  class Block
    attr_reader :block

    def initialize(expr_list)
      @block = expr_list
    end

    def empty?
      @block.empty?
    end

    def to_s
      @block.map(&:to_s).join("\n")
    end
  end
end
