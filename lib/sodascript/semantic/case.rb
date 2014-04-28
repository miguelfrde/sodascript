module Sodascript
  class Case
    attr_reader :var, :whens, :default_block

    def initialize(var, whens, default_block)
      @var = var
      @whens = whens
      @default_block = default_block
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
