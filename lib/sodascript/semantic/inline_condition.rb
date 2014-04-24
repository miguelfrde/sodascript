module Sodascript
  class InlineCondition
    attr_reader :condition, :else_expr

    def initialize(conditon, else_expr)
      @conditon = conditon
      @else_expr = else_expr
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
