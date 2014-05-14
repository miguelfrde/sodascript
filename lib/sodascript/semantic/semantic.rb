require 'set'

module Sodascript

  ##
  # Class full of utilities to make semantic analysis simpler. It manages
  # scopes, class/function/variables definitions, etc.

  class Semantic

    # Variables in the main scope
    @@variables = Set.new

    # Variables in the current function definition scope
    @@function_scope = Set.new

    # Varaibles in the current class definition scope
    @@class_scope = Set.new

    # All function names mapped to the number of parameters they have
    @@functions = Hash.new

    # All class names mapped to the number of parameters their constructors have
    @@classes = Hash.new

    # Stack of scopes
    @@stack = []

    # True if inside a class definition
    @@is_class = false

    # True if inside a function NOT a method definition
    @@is_function = false

    # True if inside a loop structure
    @@in_loop = false

    # True if inside a function OR a method definition
    @@in_function = false

    ##
    # Pushes a new block of variables onto the stack and saves them in the
    # current scope

    def self.push_new_block(*variables)
      variables.each do |var|
        fail ArgumentError, 'variable must be a String' unless
          var.is_a?(String)
        save(var)
      end
      @@stack.push(variables)
    end

    ##
    # Saves all variables in the current scope and appends them to the block on
    # top of the stack

    def self.define_in_block(*variables)
      variables.each do |var|
        fail ArgumentError, 'variable must be a String' unless
          var.is_a?(String)
        save(var)
        @@stack[-1] << var
      end
    end

    ##
    # Pops a block and removes all the variable names inside it from the current
    # scope

    def self.pop_block
      if @@is_function
        @@function_scope -= @@stack.pop
      elsif @@is_class
        @@class_scope -= @@stack.pop
      else
        @@variables -= @@stack.pop
      end
    end

    ##
    # True if the name is defined in the current scope

    def self.is_defined?(name)
      scope = (@@is_function && @@function_scope) ||
        (@@is_class && @@class_scope) ||
        @@variables
      scope.include?(name) || @@classes.include?(name) ||
        @@functions.include?(name)
    end

    ##
    # Checks if all the variables are defined in the current scope. Outputs an
    # error for each variable that is not defined.

    def self.assert_exists(*variables)
      variables.each do |variable|
        err = "Variable '#{variable}' is not defined in scope."
        SodaLogger.error(err) unless is_defined?(variable)
      end
    end

    ##
    # Checks that a function is defined. If it's not, defines it and maps it to
    # the number of parameters it has. Then evaluates the block. Changes the
    # scope to function scope.

    def self.check_function(function_name, function_params, &block)
      if @@functions.include?(function_name)
        err = "#{function_name} was defined previously. Cannot be defined twice"
        SodaLogger.error(err)
        return
      end
      define_in_block(function_name)
      @@functions[function_name] = function_params.size
      @@is_function = true
      result = function_analysis(function_name, function_params) { block.call }
      @@is_function = false
      result
    end

    ##
    # Checks if a method exists and  if it doesn't defines it, then evaluates
    # the given block.

    def self.check_method(method_name, method_params, &block)
      function_analysis(method_name, method_params) { block.call }
    end

    ##
    # Defines a class. Performs semantic analysis and code generation for all
    # its attributes and methods. If the class is already defined it prints an
    # error and doesn't check anything inside the class. Changes the scope to
    # class scope.

    def self.check_class(myclass, &block)
      if @@classes.include?(myclass.name)
        err = "#{myclass.name} was defined previously. Cannot be defined twice"
        SodaLogger.error(err)
        return
      end
      define_in_block(myclass.name)
      @@classes[myclass.name] = myclass.constructor.parameters.size
      @@is_class = true
      push_new_block('self', 'init')
      define_in_block(*myclass.parameters)
      mapper = Proc.new { |a| a.variable_names.to_a }
      define_in_block(*myclass.attributes.map(&mapper).flatten)
      methods = [myclass.private_methods, myclass.public_methods].flatten
      SodaLogger.level = SodaLogger::FAIL_LEVEL
      define_in_block(*methods.map(&:name))
      SodaLogger.level = SodaLogger::DEFAULT_LEVEL
      previous_functions = @@functions.dup
      methods.each { |m| @@functions[m.name] = m.parameters.size }
      @@functions['init'] = myclass.constructor.parameters.size
      result = block.call
      @@functions = previous_functions
      pop_block
      @@is_class = false
      result
    end

    ##
    # Sets in_loop to true, then evaluates the given block and finally, sets
    # in_loop back to its original value (if it set it back to false, then
    # nested loops won't work)

    def self.check_loop(&block)
      prev_loop_status = @@in_loop
      @@in_loop = true
      result = block.call
      @@in_loop = prev_loop_status
      result
    end

    ##
    # Perfroms semantic analysis on a function call. Checks that the function
    # exists, that it's being called with the right number of parameters,
    # that all the variables in its paramenters exist and that all function
    # calls in its paramaneters are valid. If the function call is actually a
    # class instantiation, it calls check_class_instatiation

    def self.check_function_call(fc)
      real = fc.arguments.size
      return check_class_instantiation(fc.name, real, fc.variables) if
        fc.is_instantiation
      if @@functions[fc.name].nil?
        SodaLogger.error("Function '#{fc.name}' was called, but not defined.")
        return
      end
      expected = @@functions[fc.name]
      err = "Function '#{fc.name}' called with #{real}, not #{expected} args."
      SodaLogger.error(err) if expected != real
      assert_exists(*fc.variables)
      fc.functioncalls.each { |f| check_function_call(f) }
    end

    ##
    # Performs semantic analysis for a class instantiation. Checks that the
    # class exists, that it's being instantiated with the right number of
    # parameters and that for each parameter the variables exist.

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

    ## Saves a variable in the current scope

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

    ##
    # Sets in_function to true, evaluates the block and then sets in_function to
    # back to false.

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

    ##
    # in_function accessor

    def self.in_function
      @@in_function
    end

    ##
    # in_loop accessor

    def self.in_loop
      @@in_loop
    end

    ##
    # For debuggin purposes, prints all Sodascript::Semantic attributes and
    # stops the program execution until <Enter> is hit. It also prints a
    # backtrace.

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
