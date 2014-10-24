module Restspec
  module Schema
    class SchemaExample
      attr_accessor :schema, :extensions

      def initialize(schema, extensions = {})
        self.schema = schema
        self.extensions = extensions
      end

      def value
        attributes.inject({}) do |sample, (_, attribute)|
          sample.merge({
            attribute.name => AttributeExample.new(attribute).value
          })
        end.merge(extensions)
      end

      private

      def attributes
        schema.attributes
      end
    end
  end
end
