module Restspec::Schema::Types
  # It will return an element of a set of elements while making a
  # example and checks against that same set of element while
  # validating. The following options are needed:
  #
  # elements: An array of the element to use
  #
  # @example:
  #   attribute :pet_type, one_of(elements: %w{dog cat})
  #
  class OneOfType < BasicType
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    #
    # @return [Object] A sample of the elements array.
    # @raise KeyError if the elements option was not initialized.
    def example_for(attribute)
      elements.sample
    end

    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is included in the elements.
    # @raise KeyError if the elements option was not initialized.
    def valid?(attribute, value)
      elements.include?(value)
    end

    def to_s
      "OneOfType(#{elements})"
    end

    private

    def elements
      options.fetch(:elements)
    end
  end
end
