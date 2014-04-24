module Sodascript
  class If
    attr_reader :condition, :if_block, :elsifs_block, :else_block

    def initialize(condition_expr, if_block, elsifs_block, else_block)
      @condition = condition_expr
      @if_block = if_block
      @elsifs_block = elsifs_block
      @else_block = else_block
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
