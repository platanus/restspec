module Restspec::Schema::Types
  class NullType < BasicType
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    #
    # @return nil
    def example_for(attribute)
      nil
    end

    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is nil.
    def valid?(attribute, value)
      value.nil?
    end
  end
end
