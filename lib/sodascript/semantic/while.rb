module Sodascript
  class While
    attr_reader :condition, :block

    def initialize(condition_expr, block)
      @condition = condition_expr
      @block = block
    end

    def to_s
      str = "#{Indentation.get}while (#{@condition}) {\n"
      Indentation.indent { str << "#{@block}\n" }
      "#{str}#{Indentation.get}}\n"
    end
  end
end
