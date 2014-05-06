module Sodascript
  class Unless
    attr_reader :condition, :unless_block, :else_block

    def initialize(condition_expr, unless_block, else_block)
      @condition = condition_expr
      @unless_block = unless_block
      @else_block = else_block
    end

    def to_s
      indent = Indentation.get
      str = "#{indent}if (!(#{@condition})) {\n"
      Indentation.indent { str << "#{@unless_block}\n" }
      str << "#{indent}}\n"
      str << "#{indent}else {\n"
      Indentation.indent do
        str << "#{@else_block}\n#{indent}}\n" unless else_block.empty?
      end
      str
    end
  end
end
