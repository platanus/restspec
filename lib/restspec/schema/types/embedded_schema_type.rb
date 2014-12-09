module Restspec::Schema::Types
  class EmbeddedSchemaType < BasicType
    attr_accessor :schema_name

    def initialize(options, options_when_name_is_present = {})
      if options.is_a?(Symbol)
        self.schema_name = options
        super(options_when_name_is_present)
      else
        super(options)
      end
    end

    def example_for(attribute)
      Restspec::Schema::SchemaExample.new(schema).value
    end

    def valid?(attribute, value)
      Restspec::Schema::Checker.new(schema).check!(value)
    end

    private

    def schema
      @schema ||= Restspec::SchemaStore.get(schema_name)
    end
  end
end
