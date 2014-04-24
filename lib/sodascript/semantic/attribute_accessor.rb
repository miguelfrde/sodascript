require 'set'

module Sodascript
  class AttributeAccessor
    attr_reader :type, :variable_names

    def initialize(type, variable_names)
      @type = type
      @variable_names = Set.new(variable_names)
    end

    def to_s
      # TODO: Javascript code
    end
  end
end
