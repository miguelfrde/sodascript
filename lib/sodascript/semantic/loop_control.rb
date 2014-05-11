module Sodascript
  class LoopControl
    TYPES = ['break', 'continue']

    def initialize(type)
      raise ArgumentError, "Type must be one of #{TYPES}" unless
        TYPES.include?(type)
      @type = type
    end

    def to_s
      SodaLogger.error("#{@type} can only be used inside a loop.") unless
        Semantic.in_loop
      "#{Indentation.get}#{@type};\n"
    end
  end
end
