module Sodascript
  class Print
    attr_reader :expression

    def initialize(expr)
      @expression = expr
    end

    def to_s
      "#{Indentation.get}console.log(#{@expression});"
    end
  end
end
