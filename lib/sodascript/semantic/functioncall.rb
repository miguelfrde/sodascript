require 'set'

module Sodascript

  ##
  # Function call representation. It can be a class instantiation too.

  class FunctionCall

    # Name of the function being called
    attr_reader :name

    # Arguments (expressions) passed to the function
    attr_reader :arguments

    # Variables that the arguments contain
    attr_reader :variables

    # String representation of the function call
    attr_reader :string

    # Function calls that the arguments contain
    attr_reader :functioncalls

    # True if the function call is a class instantiation (contains new before
    # the call)
    attr_reader :is_instantiation

    ##
    # Create a new function call given its name, the list of arguments and the
    # specification if the function is a class instantiation and if it's an
    # inline function (not inside a expression, assign, etc. just the function
    # call)

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

    ##
    # Depending on the name, create a function call or create a method call on
    # an object. If the name contains a '.' then it'll be a method call. A
    # method call can't be a function call since we can't check it's arguments
    # because we can't know the type of the object on which the method is called

    def self.create(name_var, args = [], new_op = false, inline = false)
      if name_var.string.include?('.')
        variables = args.inject(Set.new) { |vars, expr| vars + expr.variables }
        string = "#{name_var.string}(#{args.map(&:string).join(', ')})"
        Variable.new(name_var.name, string, variables, inline)
      else
        FunctionCall.new(name_var.name, args, new_op, inline)
      end
    end

    ##
    # Semantic analysis for the function call. For more information refer to
    # Sodascript::Semantic.check_function_call

    def to_s
      Semantic.check_function_call(self)
      return "#{Indentation.get}#{@string}" if @inline
      @string
    end
  end
end
