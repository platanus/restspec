module Restspec
  module Schema
    class Attribute
      attr_reader :name, :type

      def initialize(name, type, options = {})
        self.name = name
        self.type = type
        self.example_override = options.fetch(:example, nil)
        self.allowed_abilities = options.fetch(:for, [:checks, :examples])
      end

      def example
        @example ||= example_override
      end

      def can_generate_examples?
        allowed_abilities.include?(:examples)
      end

      def can_be_checked?
        allowed_abilities.include?(:checks)
      end

      private

      attr_writer :name, :type
      attr_accessor :example_override, :allowed_abilities
    end
  end
end
