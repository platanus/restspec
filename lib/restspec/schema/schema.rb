module Restspec
  module Schema
    class Schema
      attr_reader :name, :attributes

      def initialize(name)
        self.name = name
        self.attributes = {}
      end

      private

      attr_writer :name, :attributes
    end
  end
end
