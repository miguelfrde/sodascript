module Sodascript
  class While
    attr_reader :condition, :block

    def initialize(condition_expr, block)
      @condition = condition_expr
      @block = block
    end

    def to_s
      "while (#{@condition}) {\n#{@block}\n}\n"
    end
  end
end
