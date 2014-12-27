module Restspec::Schema::Types
  class IntegerType < BasicType
    # Generates a random number.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    #
    # @return [Fixnum] A random number.
    def example_for(attribute)
      Faker::Number.digit.to_i
    end

    # Validates if the value is an integer (Fixnum).
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is an integer.
    def valid?(attribute, value)
      value.is_a?(Fixnum)
    end
  end
end
