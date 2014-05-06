module Sodascript
  class If
    attr_reader :condition, :if_block, :elsifs, :else_block

    def initialize(condition_expr, if_block, elsifs, else_block)
      @condition = condition_expr
      @if_block = if_block
      @elsifs = elsifs
      @else_block = else_block
    end

    def to_s
      indent = Indentation.get
      str = "#{indent}if (#{@condition}) {\n"
      Indentation.indent { str << "#{@if_block}\n" }
      str << "#{indent}}\n"
      str << "#{@elsifs}\n" unless @elsifs.empty?
      unless @else_block.empty?
        Indentation.indent do
          str << "#{indent}else {\n#{@else_block}\n#{indent}}"
        end
      end
      str
    end
  end
end
