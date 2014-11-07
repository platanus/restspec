require 'faker'

module Restspec
  module Schema
    class AttributeExample < Struct.new(:attribute)
      def value
        attribute.example || type.example_for(attribute)
      end

      private

      def type
        attribute.type
      end
    end
  end
end
