module Restspec::Schema::Types
  # An embedded schema is an attribute with all
  # the options of a given schema.
  class EmbeddedSchemaType < BasicType
    attr_accessor :schema_name

    def initialize(schema_name, options = {})
      self.schema_name = schema_name
      super(options)
    end

    # Generates examples by creating a {SchemaExample} using
    # the passed schema.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema to use.
    def example_for(attribute)
      Restspec::Schema::SchemaExample.new(schema).value
    end

    # Checks if the value is an embedded valid example of the schema
    # used to initialize.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @example
    #   # Let's assume this schema
    #   schema :category do
    #     attribute :name, string
    #   end
    #
    #   # We can do this anywhere
    #   schema :product do
    #     attribute :name, string
    #     attribute :category, embedded_schema(:category)
    #   end
    #
    #   { name: 'Something', category: { name: 'Products' }  } # a valid product!
    #   { name: 'Something' } # an invalid product!
    #
    # @return [true, false] If the value is an embedded valid example of the schema.
    def valid?(attribute, value)
      begin
        Restspec::Schema::Checker.new(schema).check!(value)
        true
      rescue  Restspec::Schema::Checker::NoAttributeError,
              Restspec::Schema::Checker::InvalidationError,
              Restspec::Schema::Checker::NoObjectError
        false
      end
    end

    private

    def schema
      @schema ||= Restspec::SchemaStore.get(schema_name)
    end
  end
end
