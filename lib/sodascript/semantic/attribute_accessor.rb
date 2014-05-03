require 'set'

module Sodascript
  class AttributeAccessor
    attr_reader :type, :variable_names

    def initialize(type, variable_names)
      @type = type
      @variable_names = Set.new(variable_names)
    end

    def to_s
      @variable_names.map { |name| send("#{@type}_str", "#{name}") }.join("\n")
    end

    private

    def readable_str(name)
      "var get#{name.capitalize} = function() { return #{name}; };"
    end

    def writable_str(name)
      "var set#{name.capitalize} = function(x) { #{name} = x; };"
    end

    def attribute_str(name)
      "this.#{name} = null;"
    end

    def private_str(name)
      "var #{name} = null;"
    end
  end
end
