module Restspec::Schema::Types
  # It represent embedded hashes, but not schematic ones. For them
  # use the {EmbeddedSchemaType}.
  #
  # This Hash can receive the following options:
  #   - schema_options:
  #     - value_type: A type specifying the type of the values of the hash.
  #     - keys: What are the keys that should be present in the hash.
  #
  class HashType < BasicType
    # Generates an empty hash for a example.
    # It could be better soon.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    #
    # @return [Hash] An empty Hash.
    def example_for(attribute)
      {}
    end

    # Checks if the object is a valid hash with the specified keys if they are specified
    # or the specified value type.
    #
    # @example
    #   HashType.new.valid?(attribute, { a: 1 })
    #   # => true
    #   HashType.new(schema_options: { keys: ['age', 'name'] }).valid?(attribute, { a: 1 })
    #   # =>  false
    #   HashType.new(schema_options: { keys: ['age', 'name'] }).valid?(attribute, { age: 1, name: 'John' })
    #   # =>  true
    #   HashType.new(schema_options: { value_type: StringType.new }).valid?(attribute, { a: 1 })
    #   # =>  false
    #   HashType.new(schema_options: { value_type: StringType.new }).valid?(attribute, { a: "1" })
    #   # =>  true
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is a correct Hash.
    def valid?(attribute, value)
      value.is_a?(Hash) && valid_keys?(value) && valid_value_types?(attribute, value)
    end

    private

    def valid_keys?(value)
      keys = schema_options.fetch(:keys, nil)
      return true if keys.nil?

      keys.all? do |key|
        value.has_key?(key)
      end
    end

    def valid_value_types?(attribute, value)
      value_type = schema_options.fetch(:value_type, nil)
      return true if value_type.nil?

      value.all? do |key, val|
        value_type.totally_valid?(attribute, val)
      end
    end
  end
end
