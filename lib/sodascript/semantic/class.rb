module Sodascript
  class Class
    attr_reader :name, :block

    def initialize(name, block)
      @name = name
      @block = block
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
