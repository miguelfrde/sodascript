require 'set'

module Sodascript
  class Expression

    # List of variables that the expression contains inside
    attr_reader :variables

    # String representation of the expression
    attr_reader :string

    # List of function calls that the expression has inside
    attr_reader :functioncalls

    # Maps Sodascript operation symbols to our JavaScript standard library
    # function names. This operations mapped have two operands.
    OP_TO_CODE = {
      '+' => 'add',
      '-' => 'sub',
      '*' => 'prod',
      '/' => 'div',
      '%' => 'mod',
      '**' => 'pow',
      '<<' => 'shiftL',
      '>>' => 'shiftR',
      '^' => 'xor',
      '&' => 'bitwiseAnd',
      '|' => 'bitwiseOr'
    }

    # Maps Sodascript operation symbols to our JavaScript standard library
    # function names. This operations mapped have one operand.
    OP_TO_CODE_SINGLE = {
      '~s' => 'not',
      '-s' => 'negative',
      '+s' => '+'
    }

    ##
    # Create a new expression given a list of variables it contains, a list of
    # function calls and the string that represents it.

    def initialize(variable_list, functioncalls, string)
      @variables = Set.new(variable_list)
      @functioncalls = functioncalls
      @string = string
    end

    ##
    # Create a new expression given the right operand, the operator and the left
    # operand.

    def self.create(a, op, b)
      func = OP_TO_CODE[op]
      func_single = OP_TO_CODE_SINGLE[op]
      bvars = (b && b.variables) || Set.new
      variables = a.variables + bvars
      fcs = (a.is_a?(Expression) && a.functioncalls) || []
      fcs += (b.is_a?(Expression) && b.functioncalls) || []
      if func
        Expression.new(variables, fcs, "#{func}(#{a.string}, #{b.string})")
      elsif func_single
        Expression.new(variables, fcs, "#{func_single}(#{a})")
      else
        Expression.new(variables, fcs, "#{a.string} #{op} #{b.string}")
      end
    end

    ##
    # This method is used by the grammar to create a new expression given three
    # kinds of objects: Expression, FunctionCall or anything else (Variable, for
    # example). If the expression is a function call it adds it creates a new
    # expression with it

    def self.new_with_functioncalls(object)
      str = "#{object.string}"
      if object.is_a?(Expression)
        Expression.new(object.variables, object.functioncalls, str)
      elsif object.is_a?(FunctionCall)
        Expression.new(object.variables, [object] + object.functioncalls, str)
      else
        Expression.new(object.variables, [], str)
      end
    end

    ##
    # Perform semantic analysis and code generation for a expression. It checks
    # that all variables are defined in the current scope and that the functions
    # beign called, are called with the right number of parameters.

    def to_s
      Semantic.assert_exists(*@variables)
      @functioncalls.each { |f| Semantic.check_function_call(f) }
      @string
    end
  end
end
