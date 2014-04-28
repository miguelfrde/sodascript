require 'set'

module Sodascript
  class FunctionCall
    attr_reader :name, :arguments, :variables

    def initialize(name, args)
      @name = name
      @arguments = args
      @string = "#{@name}(#{@arguments.join(', ')})"
      @variables = args.inject(Set.new) { |vars, expr| vars + expr.variables }
      @variables << name
    end

    def self.create(name_var, args = [])
      if name_var.to_s.include?(".")
        variables = args.inject(Set.new) { |vars, expr| vars + expr.variables }
        string = "#{name_var}(#{args.join(', ')})"
        Variable.new(name_var.name, string, variables)
      else
        FunctionCall.new(name_var.name, args)
      end
    end

    def to_s
      @string
    end
  end
end
