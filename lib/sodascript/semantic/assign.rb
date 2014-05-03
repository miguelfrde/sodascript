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
      str = "#{@lhs} #{@assign_op} #{@rhs};"
      unless @inline_condition.nil?
        str = "if (#{@inline_condition.condition}) {\n#{str}\n} else {\n"
        str << "#{@lhs} #{@assign_op} #{@inline_condition.else_expr};\n}"
      end
      str
    end
  end
end
