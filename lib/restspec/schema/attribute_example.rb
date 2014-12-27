require 'faker'

module Restspec
  module Schema
    # Generates an example for a single attribute.
    class AttributeExample
      # Creates a new {AttributeExample} with an {Attribute} object.
      def initialize(attribute)
        self.attribute = attribute
      end

      # Generates an example using the hardcoded `example_override` option
      # in the attribute or by calling the #example_for method of the type.
      #
      # @return [#as_json] the generated example attribute.
      def value
        if attribute.example.present?
          attribute.example.try(:call) || attribute.example
        else
          type.example_for(attribute)
        end
      end

      private

      attr_accessor :attribute

      def type
        attribute.type
      end
    end
  end
end
