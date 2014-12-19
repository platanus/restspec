module Restspec
  module Schema
    class DSL
      attr_reader :schemas
      attr_accessor :mixins

      def initialize
        self.mixins = {}
      end

      def schema(name, &definition)
        dsl = SingleSchemaDSL.new(name)
        dsl.instance_eval(&definition)
        Restspec::SchemaStore.store(dsl.schema)
      end

      def mixin(name, &definition)
        mixins[name] = definition
      end
    end

    class SingleSchemaDSL
      attr_reader :schema, :mixins

      def initialize(name, mixins = [])
        self.schema = Schema.new(name)
        self.mixins = mixins
      end

      def attribute(name, type, options = {})
        new_attribute = Attribute.new(name, type, options)
        schema.attributes[name.to_s] = new_attribute
      end

      def include_attributes(name)
        self.instance_eval &mixins.fetch(name)
      end

      Types::ALL.each do |type_name, type_class|
        define_method(type_name) do |options = {}|
          type_class.new(options)
        end
      end

      private

      attr_writer :schema, :mixins
    end
  end
end
