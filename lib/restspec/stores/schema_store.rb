require 'delegate'

module Restspec
  module Stores
    # Provides methods for the {SchemaStore} object.
    class SchemaStoreDelegator < SimpleDelegator
      # Stores a schema. It uses the name of the schema as the hash key.
      #
      # @param schema [Restspec::Schema::Schema] the schema to store.
      # @return [Restspec::Schema::Schema] the schema inserted.
      def store(schema)
        self[schema.name] = schema
      end

      # Get the schema. It's just an alias for the Hash#[] method
      #
      # @param schema_name the name of the schema.
      # @return [Restspec::Schema::Schema, nil] the schema found.
      def get(schema_name)
        self[schema_name]
      end
    end

    # The Schema Store is a Hash extended using {Stores::SchemaStoreDelegator}
    # This is where we store the schemas to use.
    #
    # It's important to note that, because this is a Hash, there can't be
    # two schemas with the same name.
    SchemaStore = SchemaStoreDelegator.new(Hash.new)
  end

  # (see Stores::SchemaStore)
  SchemaStore = Stores::SchemaStore
end
