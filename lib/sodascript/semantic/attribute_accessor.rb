require 'set'

module Sodascript
  class AttributeAccessor
    attr_reader :type, :variable_names

    def initialize(type, variable_names)
      @type = type
      @variable_names = Set.new(variable_names)
    end

    def to_s
      indent = Indentation.get
      @variable_names.map do |name|
        send("#{@type}_str", "#{name}", indent)
      end.join("\n")
    end

    private

    def readable_str(name, indent)
      "#{indent}var get#{name.capitalize} = function() { return #{name}; };"
    end

    def writable_str(name, indent)
      "#{indent}var set#{name.capitalize} = function(x) { #{name} = x; };"
    end

    def attribute_str(name, indent)
      "#{indent}this.#{name} = null;"
    end

    def private_str(name, indent)
      "#{indent}var #{name} = null;"
    end
  end
end
