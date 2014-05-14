module Sodascript

  ##
  # Class representation
  class Class

    # Class name
    attr_reader :name

    # List of private methods
    attr_reader :private_methods

    # List of public methods
    attr_reader :public_methods

    # Constructor function
    attr_reader :constructor

    # List of attributes
    attr_reader :attributes

    # Parameters for the constructor
    attr_reader :parameters

    ##
    # Creates a new class given a name and a list of all its methods and
    # attribtues

    def initialize(name, block)
      @name = name
      @attributes = block.select { |struct| struct.is_a?(AttributeAccessor) }

      methods = block.
        select { |struct| struct.is_a?(Function) }.
        each { |m| m.use_as_method }

      @constructor = methods.select { |m| m.name == 'init' }[0]
      @constructor = Function.new('init', [], nil) if @constructor.nil?
      @constructor.use_as_method
      @parameters = @constructor.parameters.map { |param| param_namer(param) }

      @private_methods = methods.select do |m|
        m.name != 'init' && m.name[0] == '_'
      end

      @public_methods = methods.select do |m|
        m.name != 'init' && m.name[0] != '_'
      end
    end

    ##
    # Performs semantic analysis and code generation for a class.
    # Refer to Sodascript::Semantic#check_class for the semantic analysis for
    # classes. The generated code will be a function with all methods inside as
    # functions.

    def to_s
      Semantic.check_class(self) do
        str = "function #{name}(#{@parameters.join(', ')}) {\n"
        Indentation.indent do
          str << "#{@attributes.map(&:to_s).join("\n")}\n" unless
            @attributes.empty?
          str << "#{Indentation.get}var self = this;\n\n"
          str << "#{function2method(@constructor)}"
          unless @private_methods.empty?
            str << "\n#{@private_methods.map(&:to_s).join("\n")}"
          end
          unless @public_methods.empty?
            str << "\n"
            str << @public_methods.map { |m| function2method(m) }.join("\n")
          end
          str << "\n#{Indentation.get}this.init(#{@parameters.join(', ')});\n"
        end
        "#{str}#{Indentation.get}}\n"
      end
    end

    private

    ##
    # Takes the generated code for a function and removes the 'var ' part and
    # changes it for 'this.'. This is used for public methods and the
    # constructor.

    def function2method(method)
      "#{Indentation.get}this.#{method.to_s[4 + Indentation.size..-1]}"
    end

    ##
    # Changes the name of the classparameters for a name that is not possible to
    # write in Sodascript: $_param, were param is the provided parameter name.

    def param_namer(param)
      "$_#{param}"
    end
  end
end
