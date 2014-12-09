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
