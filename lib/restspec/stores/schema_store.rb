require 'delegate'

module Restspec
  module Stores
    class SchemaStoreDelegator < SimpleDelegator
      def store(schema)
        self[schema.name] = schema
      end

      def get(schema_name)
        self[schema_name]
      end
    end

    SchemaStore = SchemaStoreDelegator.new(Hash.new)
  end

  SchemaStore = Stores::SchemaStore
end
