module Sodascript
  class LoopControl
    TYPES = ['break', 'continue']

    def initialize(type)
      raise ArgumentError, "Type must be one of #{TYPES}" unless
        TYPES.include?(type)
      @type = type
    end

    def to_s
      @type
    end
  end
end
