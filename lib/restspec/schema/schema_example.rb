module Restspec
  module Schema
    # A value object that generates a example from a schema using an optional set of extensions.
    class SchemaExample
      attr_accessor :schema
      attr_accessor :extensions

      # @param schema [Restspec::Schema::Schema] the schema used to generate the example.
      # @param extensions [Hash] A set of extensions to merge with the example.
      def initialize(schema, extensions = {})
        self.schema = schema
        self.extensions = extensions
      end

      # It returns the generated example.
      # @return [Restspec::Values::SuperHash] generated example.
      def value
        example_attributes = attributes.inject({}) do |sample, (_, attribute)|
          sample.merge(attribute.name => AttributeExample.new(attribute).value)
        end.merge(extensions)

        if schema.root?
          wrap_in_root(example_attributes)
        else
          example_attributes
        end
      end

      private

      def attributes
        schema.attributes_for_intention
      end

      def wrap_in_root(hash)
        { schema.root_name => hash }
      end
    end
  end
end
