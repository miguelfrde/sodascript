module Sodascript
  class When
    attr_reader :expression, :block

    def initialize(expression, block)
      @expression = expression
      @block = block
    end

    def to_s
      str = "#{Indentation.get}case #{@expression}:\n"
      Indentation.indent { str << "#{block}\n#{Indentation.get}break;" }
      str
    end
  end
end
