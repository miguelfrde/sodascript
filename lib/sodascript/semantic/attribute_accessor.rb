require 'set'

module Sodascript

  ##
  # Attribute accessor that a class uses to define it's attributes.

  class AttributeAccessor

    # Attribute type: private, readable, writable or attribute (both)
    attr_reader :type

    # Names of the attributes of this type
    attr_reader :variable_names

    ##
    # Create a new AttributeAccessor from a type and a list of all the
    # attributes to be defined.

    def initialize(type, variable_names)
      @type = type
      @variable_names = Set.new(variable_names)
    end

    ##
    # Performs code generation for the attributes
    # readable x -> var x = null; var getX() { return x; }
    # writable x -> var x = null;var setX(v) { x = v; }
    # attribute x -> this.x = null;
    # private x -> var x = null;

    def to_s
      indent = Indentation.get
      @variable_names.map do |name|
        send("#{@type}_str", "#{name}", indent)
      end.join("\n")
    end

    private

    # Performs code generation for a readble attribute
    # readable x -> var x = null; var getX() { return x; }
    def readable_str(name, indent)
      s = "#{private_str(name, indent)}\n"
      "#{s}#{indent}var get#{name.capitalize} = function() { return #{name}; };"
    end

    # Performs code generation for a writable attribute
    # writable x -> var x = null;var setX(v) { x = v; }
    def writable_str(name, indent)
      s = "#{private_str(name, indent)}\n"
      "#{s}#{indent}var set#{name.capitalize} = function(x) { #{name} = x; };"
    end

    # Performs code generation for a public attribute
    # attribute x -> this.x = null;
    def attribute_str(name, indent)
      "#{indent}this.#{name} = null;"
    end

    # Performs code generation for a private attribute
    # private x -> var x = null;
    def private_str(name, indent)
      "#{indent}var #{name} = null;"
    end
  end
end
