module Sodascript

  ##
  # Assign statement. It can be of two types:
  # lhs op rhs (ex: x = 1 + 2)
  # lhs op rhs if cond else (ex: x = 1 + 2 if y == 1 else 3)

  class Assign

    # Left hand side of the assign statement
    attr_reader :lhs

    # Right hand side of the assign statement
    attr_reader :rhs

    # Assign operation
    attr_reader :assign_op

    # Inline optional condition of the assign statement.
    # Instance of InlineCondition
    attr_reader :inline_condition

    ##
    # Create a new Assign object. It receives a lhs (Variable),
    # a rhs (Expression), an operation (string) and an inline condition
    # (InlineCondition).

    def initialize(expr_lhs, assign_op, expr_rhs, inline_condition = nil)
      @lhs = expr_lhs
      @rhs = expr_rhs
      @assign_op = assign_op
      @inline_condition = inline_condition
    end

    ##
    # Preforms semantic analysis and code generation for an assign expression.
    # Example:
    # Soda: x = 1 if y == 2 else 3
    # Javascript:
    # [var x;] if (y == 2) { x = 1; } else { x = 3; }

    def to_s
      Semantic.assert_exists(@lhs.name)
      str = Indentation.get

      perform_semantic_actions(str)

      true_assign = "#{assign_code(@lhs, @assign_op, @rhs)}"

      if @inline_condition.nil?
        str << "#{true_assign}"
      else
        str << "if (#{@inline_condition.condition}) {\n"
        Indentation.indent { str << "#{Indentation.get}#{true_assign}\n" }
        str << "#{Indentation.get}} else {\n"
        Indentation.indent do
          i = Indentation.get
          code = assign_code(@lhs, @assign_op, @inline_condition.else_expr)
          str << "#{i}#{code}\n"
        end
        str << "#{Indentation.get}}"
      end
      str
    end

    private

    ##
    # Checks taht the lhs is defined and if it's not, it defines it.

    def perform_semantic_actions(str)
      unless Semantic.is_defined?(@lhs.name) || @lhs.complex? || @lhs.self?
        str << "var #{@lhs.name};\n#{Indentation.get}"
        Semantic.define_in_block(@lhs.name)
      end
    end

    def assign_code(lhs, op, rhs)
      return "#{lhs} #{op} #{rhs};" if op == '='
      function = Expression::OP_TO_CODE[op[0..-2]]
      "#{lhs} = #{function}(#{lhs}, #{rhs});"
    end
  end
end
