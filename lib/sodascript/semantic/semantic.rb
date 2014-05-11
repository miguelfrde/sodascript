require 'set'

module Sodascript
  class Semantic
    @@variables = Set.new
    @@function_scope = Set.new
    @@class_scope = Set.new

    @@functions = Hash.new
    @@classes = Hash.new
    @@stack = []

    @@is_class = false
    @@is_function = false

    @@in_loop = false
    @@in_function = false

    def self.push_new_block(*variables)
      variables.each do |var|
        fail ArgumentError, 'variable must be a String' unless
          var.is_a?(String)
        save(var)
      end
      @@stack.push(variables)
    end

    def self.define_in_block(*variables)
      variables.each do |var|
        fail ArgumentError, 'variable must be a String' unless
          var.is_a?(String)
        save(var)
        @@stack[-1] << var
      end
    end

    def self.pop_block
      if @@is_function
        @@function_scope -= @@stack.pop
      elsif @@is_class
        @@class_scope -= @@stack.pop
      else
        @@variables -= @@stack.pop
      end
    end

    def self.is_defined?(name)
      scope = (@@is_function && @@function_scope) ||
        (@@is_class && @@class_scope) ||
        @@variables
      scope.include?(name) || @@classes.include?(name) ||
        @@functions.include?(name)
    end

    def self.assert_exists(*variables)
      variables.each do |variable|
        err = "Variable '#{variable}' is not defined in scope."
        SodaLogger.error(err) unless is_defined?(variable)
      end
    end

    def self.check_function(function_name, function_params, &block)
      define_in_block(function_name)
      @@functions[function_name] = function_params.size
      @@is_function = true
      result = function_analysis(function_name, function_params) { block.call }
      @@is_function = false
      result
    end

    def self.check_method(method_name, method_params, &block)
      function_analysis(method_name, method_params) { block.call }
    end

    def self.check_class(myclass, &block)
      define_in_block(myclass.name)
      @@classes[myclass.name] = myclass.constructor.parameters.size
      @@is_class = true
      push_new_block('self', 'init')
      define_in_block(*myclass.parameters)
      mapper = Proc.new { |a| a.variable_names.to_a }
      define_in_block(*myclass.attributes.map(&mapper).flatten)
      methods = [myclass.private_methods, myclass.public_methods].flatten
      define_in_block(*methods.map(&:name))
      methods.each { |m| @@functions[m.name] = m.parameters.size }
      @@functions['init'] = myclass.constructor.parameters.size
      result = block.call
      methods.each { |m| @@functions.delete(m.name) }
      @@functions.delete('init')
      pop_block
      @@is_class = false
      result
    end

    def self.check_loop(&block)
      prev_loop_status = @@in_loop
      @@in_loop = true
      result = block.call
      @@in_loop = prev_loop_status
      result
    end

    def self.check_function_call(fc)
      real = fc.arguments.size
      return check_class_instantiation(fc.name, real, fc.variables) if
        fc.is_instantiation
      if @@functions[fc.name].nil?
        SodaLogger.error("Function '#{fc.name}' was called, but not defined.")
        debug
        return
      end
      expected = @@functions[fc.name]
      err = "Function '#{fc.name}' called with #{real}, not #{expected} args."
      SodaLogger.error(err) if expected != real
      assert_exists(*fc.variables)
      fc.functioncalls.each { |f| check_function_call(f) }
    end

    def self.check_class_instantiation(name, args, variables)
      if @@classes[name].nil?
        SodaLogger.error("Class '#{name}' was instantiated, but not defined.")
        return
      end
      expected = @@classes[name]
      err = "Class '#{name}' instantiated with #{args}, not #{expected} args."
      SodaLogger.error(err) if expected != args
      assert_exists(*variables)
    end

    def self.save(var)
      SodaLogger.error("Variable '#{var}' already exists in scope.") if
        is_defined?(var)
      if @@is_function
        @@function_scope << var
      elsif @@is_class
        @@class_scope << var
      else
        @@variables << var
      end
    end

    def self.function_analysis(function_name, function_params, &block)
      @@in_function = true
      push_new_block
      #define_in_block(function_name) if @@is_function
      define_in_block(*function_params)
      result = block.call
      pop_block
      @@in_function = false
      result
    end

    def self.in_function
      @@in_function
    end

    def self.in_loop
      @@in_loop
    end

    def self.debug
      puts caller
      puts "is_function: #{@@is_function}"
      puts "is_class: #{@@is_class}"
      puts "in_function: #{@@in_function}"
      puts "in_loop: #{@@in_loop}"
      puts "class_scope: #{@@class_scope.to_a}"
      puts "function_scope: #{@@function_scope.to_a}"
      puts "variables: #{@@variables.to_a}"
      puts "functions: #{@@functions}"
      puts "classes: #{@@classes}"
      puts "#{@@stack}"
      $stdin.gets
    end
  end
end
