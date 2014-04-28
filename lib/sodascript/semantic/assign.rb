module Sodascript
  class Assign
    attr_reader :lhs, :rhs, :assign_op, :inline_condition

    def initialize(expr_lhs, assign_op, expr_rhs, inline_condition = nil)
      @lhs = expr_lhs
      @rhs = expr_rhs
      @assign_op = assign_op
      @inline_condition = inline_condition
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
