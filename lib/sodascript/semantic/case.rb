module Sodascript
  class Case
    attr_reader :expr, :whens, :default_block

    def initialize(expr, whens, default_block)
      @expr = expr
      @whens = whens
      @default_block = default_block
    end

    def to_s
      indent = Indentation.get
      str = "#{indent}switch (#{@expr}) {\n"
      str << "#{@whens.map(&:to_s).join("\n")}\n"
      str << "#{indent}default:\n"
      Indentation.indent { str << "#{@default_block}\n" }
      "#{str}#{indent}}\n"
    end
  end
end
