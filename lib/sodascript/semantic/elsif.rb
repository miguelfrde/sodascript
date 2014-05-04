module Sodascript
  class Elsif
    attr_reader :condition, :block

    def initialize(condition_expr, block)
      @condition = condition_expr
      @block = block
    end

    def to_s
      str = "#{Indentation.get}else if (#{@condition}) {\n"
      Indentation.increment
      str << "#{@block}\n"
      Indentation.decrement
      "#{str}#{Indentation.get}}"
    end
  end
end
