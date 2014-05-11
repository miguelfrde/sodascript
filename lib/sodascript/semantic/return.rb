module Sodascript
  class Return
    attr_reader :expression

    def initialize(expr = nil)
      @expression = expr
    end

    def to_s
      unless Semantic.in_function
        SodaLogger.error('return can only be used inside a function definition')
      end
      "#{Indentation.get}return #{@expression};"
    end
  end
end
