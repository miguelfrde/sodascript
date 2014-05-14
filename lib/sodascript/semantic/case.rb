module Sodascript

  ##
  # Case statement representation.

  class Case

    # Case expression
    attr_reader :expr

    # List of when instances
    attr_reader :whens

    # Optional default block
    attr_reader :default_block

    ##
    # Creates a new case instance given the case expression, a list of whens
    # and the default block (can be nil)

    def initialize(expr, whens, default_block)
      @expr = expr
      @whens = whens
      @default_block = default_block
    end

    ##
    # Performs semantic analysis and code generation for the case.
    # Example:
    # case x
    # when 1 do y = 2
    # when 4 do y = 6
    # default y = 1
    # end
    #
    # Compiles to:
    # switch(x) {
    # case 1:
    #   y = 2;
    #   break;
    # case 4:
    #   y = 6;
    #   break;
    # default:
    #   y = 1;
    # }

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
