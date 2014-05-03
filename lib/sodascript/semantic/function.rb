module Sodascript
  class Function
    attr_reader :name, :parameters, :block

    def initialize(name, parameters, block)
      @name = name
      @parameters = parameters
      @block = block
    end

    def to_s
      "var #{name} = function(#{@parameters.join(', ')}) {\n#{block}\n};"
    end
  end
end
