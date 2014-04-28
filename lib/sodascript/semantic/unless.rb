module Sodascript
  class Unless
    attr_reader :condition, :unless_block, :else_block

    def initialize(condition_expr, unless_block, else_block)
      @condition = condition
      @unless_block = unless_block
      @else_block = else_block
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
