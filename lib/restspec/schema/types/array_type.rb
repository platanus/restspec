module Restspec::Schema::Types
  class ArrayType < BasicType
    # Generates an example array.
    #
    # @example without a parameterized type
    #   # schema
    #   attribute :name, array
    #   # examples
    #   example_for(schema.attributes[:name])
    #   # => []
    #
    # @example with a parameterized type and no length example option
    #   # schema
    #   attribute :name, array.of(string)
    #   # examples
    #   example_for(schema.attributes[:name])
    #   # => ['hola', 'mundo'] # the length is something randomly between 1 a 5.
    #
    # @example with a parameterized type and length example option
    #   # schema
    #   attribute :name, array(length: 2).of(string) # or:
    #   attribute :name, array(example_options: { length: 2}).of(string)
    #   # examples
    #   example_for(schema.attributes[:name])
    #   # => ['hola', 'mundo'] # the length will always be 2
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @return [Array] Generated array for examples.
    def example_for(attribute)
      length_only_works_with_parameterized_types!

      example_length.times.map do
        parameterized_type.example_for(attribute)
      end
    end

    # Validates if the array is valid.
    #
    # - Without a parameterized type, it only checks if the value is an array.
    # - With a parameterized type, it checks is every object inside the array
    #   is valid against the parameterized type.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the array is valid.
    def valid?(attribute, value)
      is_array = value.is_a?(Array)
      if parameterized_type
        is_array && value.all? do |item|
          parameterized_type.totally_valid?(attribute, item)
        end
      else
        is_array
      end
    end

    private

    def example_length
      example_options.fetch(:length, internal_length)
    end

    def internal_length
      return 0 if !parameterized_type
      rand(1..5)
    end

    def length_only_works_with_parameterized_types!
      if example_options.has_key?(:length) && !parameterized_type
        raise "To use the :length option you need to have a parameterized_type or we can't generate the array"
      end
    end
  end
end
