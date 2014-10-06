module Restspec
  module Schema
    class SchemaExample < Struct.new(:schema)
      def value
        attributes.inject({}) do |sample, (_, attribute)|
          sample.merge({
            attribute.name => AttributeExample.new(attribute.type).value
          })
        end
      end

      private

      def attributes
        schema.attributes
      end
    end
  end
end
