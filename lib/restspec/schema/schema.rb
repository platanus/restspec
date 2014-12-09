module Restspec
  module Schema
    class Schema
      attr_reader :name, :attributes

      def initialize(name)
        self.name = name
        self.attributes = {}
      end

      def extend_with(without: [])
        without.each { |attribute_name| attributes.delete(attribute_name.to_s) }
        self
      end

      private

      attr_writer :name, :attributes
    end
  end
end
