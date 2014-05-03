module Sodascript
  class When
    attr_reader :expression, :block

    def initialize(expression, block)
      @expression = expression
      @block = block
    end

    def to_s
      "case #{@expression} {\n#{block}\nbreak;\n}\n"
    end
  end
end
