require 'set'

module Sodascript
  class Expression
    attr_reader :variables, :string, :functioncalls

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

    OP_TO_CODE_SINGLE = {
      '~s' => 'not',
      '-s' => 'negative',
      '+s' => 'positive'
    }

    def initialize(variable_list, functioncalls, string)
      @variables = Set.new(variable_list)
      @functioncalls = functioncalls
      @string = string
    end

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

    def to_s
      Semantic.assert_exists(*@variables)
      @functioncalls.each { |f| Semantic.check_function_call(f) }
      @string
    end
  end
end
