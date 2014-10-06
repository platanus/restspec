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

      def attribute(name, type)
        schema.attributes[name.to_s] = Attribute.new(name, type)
      end

      private

      attr_writer :schema
    end
  end
end
