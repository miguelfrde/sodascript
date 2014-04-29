module Sodascript
  class InlineCondition
    attr_reader :condition, :else_expr

    def initialize(condition, else_expr)
      @condition = condition
      @else_expr = else_expr
    end
  end
end
