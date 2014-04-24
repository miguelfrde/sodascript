module Sodascript
  class When
    attr_reader :expression, :block

    def initialize(expression, block)
      @expression = expression
      @block = block
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
