module Sodascript
  class Class
    attr_reader :name, :block, :private_methods, :public_methods, :constructor
    attr_reader :attributes, :parameters

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

    def function2method(method)
      "#{Indentation.get}this.#{method.to_s[4 + Indentation.size..-1]}"
    end

    def param_namer(param)
      "$_#{param}"
    end
  end
end
