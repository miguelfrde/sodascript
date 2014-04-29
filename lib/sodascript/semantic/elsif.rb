module Sodascript
  class Elsif
    attr_reader :condition, :block

    def initialize(condition_expr, block)
      @condition = condition_expr
      @block = block
    end

    def to_s
      "else if (#{@condition}) {\n#{@block}\n}"
    end
  end
end
