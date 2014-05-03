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
      str = "if (#{@condition}) {\n"
      str << "#{@if_block}\n}\n"
      str << "#{@elsifs}\n" unless @elsifs.empty?
      str << "else {\n#{@else_block}\n}" unless @else_block.empty?
      str
    end
  end
end
