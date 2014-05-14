module Sodascript
  ##
  # Class that just represents breaks and continues and asserts that they are
  # used only where they are expected, inside a loop structure

  class LoopControl

    # Names of the loop control structures that will be checked
    TYPES = ['break', 'continue']

    ##
    # Creates a new LoopControl object given its type

    def initialize(type)
      raise ArgumentError, "Type must be one of #{TYPES}" unless
        TYPES.include?(type)
      @type = type
    end

    ##
    # Performs semantic analysis and code generation for the loop control
    # structure. This only checks that the structure is being used inside a loop

    def to_s
      SodaLogger.error("#{@type} can only be used inside a loop.") unless
        Semantic.in_loop
      "#{Indentation.get}#{@type};\n"
    end
  end
end
