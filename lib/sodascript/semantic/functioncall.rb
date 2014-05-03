require 'set'

module Sodascript
  class FunctionCall
    attr_reader :name, :arguments, :variables

    def initialize(name, args, new_op = false)
      @name = name
      @arguments = args
      @string = "#{@name}(#{@arguments.join(', ')})"
      @string = "new #{@string}" if new_op
      @variables = args.inject(Set.new) { |vars, expr| vars + expr.variables }
      @variables << name
    end

    def self.create(name_var, args = [], new_op = false)
      if name_var.to_s.include?(".")
        variables = args.inject(Set.new) { |vars, expr| vars + expr.variables }
        string = "#{name_var}(#{args.join(', ')})"
        Variable.new(name_var.name, string, variables)
      else
        FunctionCall.new(name_var.name, args, new_op)
      end
    end

    def to_s
      @string
    end
  end
end
