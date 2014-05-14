module Sodascript

  ##
  # Function/method representation

  class Function

    # Function/method name
    attr_reader :name

    # List of function/method parameters (strings)
    attr_reader :parameters

    # Function block
    attr_reader :block

    ##
    # Creates a new function/method from a name, parameters and block

    def initialize(name, parameters, block)
      @name = name
      @parameters = parameters
      @block = block
      @method = false
    end

    ##
    # The function will be a method for now on

    def use_as_method
      @method = true
    end

    ##
    # Perform semantic analysis and code generation for the function/method. For
    # more information refer to Sodascript::Semantic.check_method and
    # Sodascript::Semantic.check_function

    def to_s
      if @method
        Semantic.check_method(@name, @parameters) { code }
      else
        Semantic.check_function(@name, @parameters) { code }
      end
    end

    private

    ##
    # Code generation for the function. This is executed by Semantic after
    # setting the function/method scope.

    def code
      str = Indentation.get
      str << "var #{name} = function(#{@parameters.join(', ')}) {\n"
      Indentation.indent { str << "#{block}\n" }
      str << "#{Indentation.get}};\n"
      str
    end
  end
end
