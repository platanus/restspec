require 'faker'

module Restspec
  module Schema
    class AttributeExample < Struct.new(:attribute)
      def value
        if attribute.example.present?
          attribute.example.try(:call) || attribute.example
        else
          type.example_for(attribute)
        end
      end

      private

      def type
        attribute.type
      end
    end
  end
end
