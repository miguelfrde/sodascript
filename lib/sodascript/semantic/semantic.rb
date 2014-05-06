require 'set'

module Sodascript
  module Semantic
    @variables = Set.new # Guarantee O(1) access to variables
    @stack = [] # Simple interface to add lots of variables
    @in_class_status = false
    @in_function_status = false
    @in_loop_status = false

    def self.push(*variables)
      variables.each do |var|
        fail ArgumentError, 'variable must be a String' unless
          var.is_a?(String)
        @variables << var
      end
      @stack.push(variables)
    end

    def self.pop
      @variables -= @stack.pop
    end

    def self.defined?(variable)
      @variables.include?(variable)
    end

    # NOTE: this section is horrible, but sadly Ruby doesn't support
    # attr_* methods as we would expect in Modules. We could extend Module
    # as Rails does, but let's not complicate it for now.

    def self.in_class(status)
      @in_class_status = status
    end

    def self.in_class?
      @in_class_status
    end

    def self.in_function(status)
      @in_function_status = status
    end

    def self.in_function?
      @in_function_status
    end

    def self.in_loop(status)
      @in_loop_status = status
    end

    def self.in_loop?
      @in_loop_status
    end
  end
end
