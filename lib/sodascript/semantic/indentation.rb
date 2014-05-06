module Sodascript
  module Indentation
    @size = 0
    INDENTATION = '  '

    def self.increment
      @size += 1
    end

    def self.decrement
      @size -= 1
    end

    def self.get
      INDENTATION * @size
    end

    def self.increment_and_get
      increment_indent
      indentation
    end

    def self.decrement_and_get
      decrement_indent
      indentation
    end

    def self.indent(&block)
      increment
      block.call
      decrement
    end

    def self.size
      @size * INDENTATION.size
    end
  end
end
