module Sodascript

  ##
  # Auxiliary class for the optional condition in Sodascript::Assign

  class InlineCondition

    # Conditional expression
    attr_reader :condition

    # Else expression that will be assigned if the condition fails
    attr_reader :else_expr

    ##
    # Creates a new inline condition, given the condition and the else
    # expression

    def initialize(condition, else_expr)
      @condition = condition
      @else_expr = else_expr
    end
  end
end
