module Sodascript
  class Class
    attr_reader :name, :block

    def initialize(name, block)
      @name = name
      @attributes = block.select { |struct| struct.is_a?(AttributeAccessor) }
      @methods = block.select { |struct| struct.is_a?(Function) }
      @constructor = @methods.select { |m| m.name == 'init' }[0]
      @private_methods = @methods.select do |m|
        m.name != 'init' && m.name[0] == '_'
      end
      @public_methods = @methods.select do |m|
        m.name != 'init' && m.name[0] != '_'
      end
    end

    def to_s
      str = "function #{name}(#{@constructor.parameters.join(', ')}) {\n"
      str << "#{@attributes.map(&:to_s).join("\n")}\n" unless @attributes.empty?
      str << "var self = this;\n"
      unless @private_methods.empty?
        str << "\n"
        str << "#{@private_methods.map(&:to_s).join("\n\n")}\n"
      end
      unless @public_methods.empty?
        str << "\n"
        str << @public_methods.map { |m| function_to_method(m) }.join("\n")
      end
      str << "\n#{@constructor.block}\n" unless @constructor.block.empty?
      "#{str}}\n"
    end

    private

    def function_to_method(method)
      "this.#{method.to_s[4..-1]}\n"
    end
  end
end
