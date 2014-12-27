module Restspec::Schema::Types
  class BooleanType < BasicType
    # Generates an example boolean.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @return [true, false] One of `true` and `false`, randomly.
    def example_for(attribute)
      [true, false].sample
    end

    # Validates is the value is a boolean.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is one of true and false.
    def valid?(attribute, value)
      [true, false].include?(value)
    end
  end
end
