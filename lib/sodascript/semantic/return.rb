module Sodascript
  class Return
    attr_reader :expression

    def initialize(expr = nil)
      @expression = expr
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
