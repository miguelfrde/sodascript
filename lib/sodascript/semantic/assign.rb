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
      str = Indentation.get

      perform_semantic_actions(str)

      true_assign = "#{@lhs} #{@assign_op} #{@rhs};"

      if @inline_condition.nil?
        str << "#{true_assign}"
      else
        str << "if (#{@inline_condition.condition}) {\n"
        Indentation.indent { str << "#{Indentation.get}#{true_assign}\n" }
        str << "#{Indentation.get}} else {\n"
        Indentation.indent do
          i = Indentation.get
          str << "#{i}#{@lhs} #{@assign_op} #{@inline_condition.else_expr};\n"
        end
        str << "#{Indentation.get}}"
      end
      str
    end

    private

    def perform_semantic_actions(str)
      unless Semantic.is_defined?(@lhs.name) || @lhs.complex? || @lhs.self?
        str << "var #{@lhs.name};\n#{Indentation.get}"
        Semantic.define_in_block(@lhs.name)
      end
    end
  end
end
