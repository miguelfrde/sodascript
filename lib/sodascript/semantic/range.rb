module Sodascript
  class Range
    attr_reader :start, :end, :step

    def initialize(start, exclusive_upper_limit, step = 1)
      @start = start
      @end = exclusive_upper_limit
      @step = step
    end

    def to_s
      "range(#{@start}, #{@end}, #{@step})"
    end
  end
end
