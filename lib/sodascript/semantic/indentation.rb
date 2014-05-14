module Sodascript

  ##
  # This module is used to indent the compiled javascript code, so that it's
  # easier to read and debug.

  module Indentation

    # Number of indentation spaces that will be printed
    @size = 0

    # Indentation symbol(s)
    INDENTATION = '  '

    ##
    # Increment indentation by one

    def self.increment
      @size += 1
    end

    ##
    # Decrement indentation by 1

    def self.decrement
      @size -= 1
    end

    ##
    # Get indentation string

    def self.get
      INDENTATION * @size
    end

    ##
    # Increment and return indentation

    def self.increment_and_get
      increment_indent
      indentation
    end

    ## Decrement and return indentation

    def self.decrement_and_get
      decrement_indent
      indentation
    end

    ##
    # This method is useful because it automatically increments the indentation
    # before evaluating a block and automatically decrements it after the block
    # has been evaluated.

    def self.indent(&block)
      increment
      result = block.call
      decrement
      result
    end

    ##
    # Return total indentation size. Useful when INDENTATION consists of more
    # than one symbol

    def self.size
      @size * INDENTATION.size
    end
  end
end
