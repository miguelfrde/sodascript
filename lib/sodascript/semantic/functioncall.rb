require 'set'

module Sodascript
  class FunctionCall
    attr_reader :name, :arguments, :variables, :string, :functioncalls
    attr_reader :is_instantiation

    def initialize(name, args, new_op = false, inline = false)
      @name = name
      @arguments = args
      @string = "#{@name}(#{@arguments.map(&:string).join(', ')})"
      @string = "new #{@string}" if new_op
      @variables = args.inject(Set.new) { |vars, expr| vars + expr.variables }
      @variables << name
      @inline = inline
      @is_instantiation = new_op
      @functioncalls = args.map { |arg| arg.functioncalls }.flatten
    end

    def self.create(name_var, args = [], new_op = false, inline = false)
      if name_var.string.include?(".")
        variables = args.inject(Set.new) { |vars, expr| vars + expr.variables }
        string = "#{name_var.string}(#{args.map(&:string).join(', ')})"
        Variable.new(name_var.name, string, variables, inline)
      else
        FunctionCall.new(name_var.name, args, new_op, inline)
      end
    end

    def to_s
      Semantic.check_function_call(self)
      return "#{Indentation.get}#{@string}" if @inline
      @string
    end
  end
end
