module Sodascript
  class For
    attr_reader :var, :iterable, :block

    def initialize(var, iterable, block)
      @var = var
      @iterable = iterable
      @block = block
    end

    def to_s
      Semantic.check_loop do
        Semantic.push_new_block(@var.name)
        str = "#{Indentation.get}#{@iterable}.forEach(function(#{@var}) {\n"
        Indentation.indent { str << "#{@block}\n" }
        Semantic.pop_block
        "#{str}#{Indentation.get}});"
      end
    end
  end
end
