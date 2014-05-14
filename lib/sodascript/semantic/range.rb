module Sodascript

  ##
  # Range representation

  class Range

    # Initial value for range (inclusive)
    attr_reader :start

    # Final value for range (exclusive)
    attr_reader :end

    # Increment or decrement if the number is negative
    attr_reader :step

    ##
    # Create a new range given the start value (inclusive), the maximum value
    # (exclusive), and the step. The step defaults to 1 if not provided.

    def initialize(start, exclusive_upper_limit, step = 1)
      @start = start
      @end = exclusive_upper_limit
      @step = step
    end

    ##
    # Code generation and semantic analysis for a range.
    # Example:
    # 1..10,2 -> range(1, 10, 2)

    def to_s
      "range(#{@start}, #{@end}, #{@step})"
    end
  end
end
