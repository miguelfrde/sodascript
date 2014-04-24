module Sodascript
  class Range
    attr_reader :start, :end, :step

    def initialize(start, exclusive_upper_limit, step = 1)
      @start = start
      @end = exclusive_upper_limit
      @step = step
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
