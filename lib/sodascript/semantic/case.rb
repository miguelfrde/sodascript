module Sodascript
  class Case
    attr_reader :var, :whens, :default_block

    def initialize(var, whens, default_block)
      @var = var
      @whens = whens
      @default_block = default_block
    end

    def to_s
      indent = Indentation.get
      str = "#{indent}switch (#{@var}) {\n"
      str << "#{@whens.map(&:to_s).join("\n")}\n"
      str << "#{indent}default:\n"
      Indentation.indent { str << "#{@default_block}\n" }
      "#{str}#{indent}}\n"
    end
  end
end
