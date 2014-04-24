module Sodascript
  class For
    attr_reader :var, :iterable, :block

    def initialize(var, iterable, block)
      @var = var
      @iterable = iterable
      @block = block
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
