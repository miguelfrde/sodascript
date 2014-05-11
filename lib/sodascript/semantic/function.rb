module Sodascript
  class Function
    attr_reader :name, :parameters, :block

    def initialize(name, parameters, block)
      @name = name
      @parameters = parameters
      @block = block
      @method = false
    end

    def is_method
      @method = true
    end

    def to_s
      if @method
        Semantic.check_method(@name, @parameters) { code }
      else
        Semantic.check_function(@name, @parameters) { code }
      end
    end

    private

    def code
      str = Indentation.get
      str << "var #{name} = function(#{@parameters.join(', ')}) {\n"
      Indentation.indent { str << "#{block}\n" }
      str << "#{Indentation.get}};\n"
      str
    end
  end
end
