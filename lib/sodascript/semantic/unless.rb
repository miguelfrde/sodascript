module Sodascript
  class Unless
    attr_reader :condition, :unless_block, :else_block

    def initialize(condition_expr, unless_block, else_block)
      @condition = condition_expr
      @unless_block = unless_block
      @else_block = else_block
    end

    def to_s
      str = "if (!(#{@condition})) {\n"
      str << "#{@unless_block}\n}\n"
      str << "else {\n#{@else_block}\n}\n" unless else_block.empty?
      str
    end
  end
end
