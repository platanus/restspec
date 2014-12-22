module Restspec
  class << self
    # Shortcut for find a schema by name, create a {Restspec::Schema::SchemaExample} and call its {Restspec::Schema::SchemaExample#value value} method to get a example.
    #
    # @param schema_name [Symbol] The name of the schema.
    # @param extensions [Hash] A set of extensions for the example.
    #
    # @example Without extensions
    #   Restspec.example_for(:person) # { name: 'John', age: 25 }
    #
    # @example With extensions
    #   Restspec.example_for(:person, age: 18) # { name: 'John', age: 18 }
    def example_for(schema_name, extensions = {})
      schema = Restspec::SchemaStore.get(schema_name)
      Schema::SchemaExample.new(schema, extensions).value
    end
  end
end
