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
        attributes.inject({}) do |sample, (_, attribute)|
          if attribute.can_generate_examples?
            sample.merge(attribute.name => AttributeExample.new(attribute).value)
          else
            sample
          end
        end.merge(extensions)
      end

      private

      def attributes
        schema.attributes
      end
    end
  end
end
