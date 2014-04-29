module Sodascript
  class Case
    attr_reader :var, :whens, :default_block

    def initialize(var, whens, default_block)
      @var = var
      @whens = whens
      @default_block = default_block
    end

    def to_s
      cases = @whens.map(&:to_s).join("\n")
      str = "switch #{@var} {\n"
      str << "#{cases}"
      str << "default:\n#{@default_block}\n}\n"
      str
    end
  end
end
