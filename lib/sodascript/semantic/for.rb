module Sodascript
  class For
    attr_reader :var, :iterable, :block

    def initialize(var, iterable, block)
      @var = var
      @iterable = iterable
      @block = block
    end

    def to_s
      str = "#{Indentation.get}#{@iterable}.forEach(function(#{@var}) {\n"
      Indentation.indent { str << "#{@block}\n" }
      str << "#{Indentation.get}});"
    end
  end
end
