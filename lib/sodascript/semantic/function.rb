module Sodascript
  class Function
    attr_reader :name, :parameters, :block

    def initialize(name, parameters, block)
      @name = name
      @parameters = parameters
      @block = block
    end

    def to_s
      str = Indentation.get
      str << "var #{name} = function(#{@parameters.join(', ')}) {\n"
      Indentation.indent { str << "#{block}\n" }
      str << "#{Indentation.get}};\n"
    end
  end
end
