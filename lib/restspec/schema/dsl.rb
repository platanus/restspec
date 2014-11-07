module Restspec
  module Schema
    class DSL
      attr_reader :schemas

      def initialize
        self.schemas = {}
      end

      def schema(name, &definition)
        dsl = SingleSchemaDSL.new(name)
        dsl.instance_eval(&definition)
        schemas[name] = dsl.schema
      end

      private

      attr_writer :schemas
    end

    class SingleSchemaDSL
      attr_reader :schema

      def initialize(name)
        self.schema = Schema.new(name)
      end

      def attribute(name, type, options = {})
        new_attribute = Attribute.new(name, type, options)
        schema.attributes[name.to_s] = new_attribute
      end

      Types::ALL.each do |type_name, type_class|
        define_method(type_name) do |options = {}|
          type_class.new(options)
        end
      end

      private

      attr_writer :schema
    end
  end
end
