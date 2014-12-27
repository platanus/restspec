module Restspec::Schema::Types
  class StringType < BasicType
    # Generates a random word.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    #
    # @return [String] A random word.
    def example_for(attribute)
      Faker::Lorem.word
    end

    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is a string.
    def valid?(attribute, value)
      value.is_a?(String)
    end
  end
end
