require 'set'

module Sodascript
  class Expression
    attr_reader :variables
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

    def initialize(variable_list, string)
      @variables = Set.new(variable_list)
      @string = string
    end

    def self.create(a, op, b)
      fun = OP_TO_CODE[op]
      fun_single = OP_TO_CODE_SINGLE[op]
      bvars = (b && b.variables) || Set.new
      variables = a.variables + bvars
      (fun && Expression.new(variables, "#{fun}(#{a}, #{b})")) ||
        (fun_single && Expression.new(variables, "#{fun_single}(#{a})")) ||
        Expression.new(variables, "#{a} #{op} #{b}")
    end

    def to_s
      @string
    end
  end
end
