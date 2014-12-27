module Restspec::Schema::Types
  # Represents a decimal number. It has the following options:
  #   - example_options:
  #     - integer_part: The integer part precision of the generated decimal. (Default: 2)
  #     - decimal_part: The decimal part precision of the generated decimal. (Default: 2)
  class DecimalType < BasicType
    # Generates a random decimal number of 2 digits as integer part
    # and 2 digits as decimal part. Both can be overrided using the
    # example options `integer_part` and `decimal_part`.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @return A random decimal number.
    def example_for(attribute)
      integer_part = example_options.fetch(:integer_part, 2)
      decimal_part = example_options.fetch(:decimal_part, 2)

      Faker::Number.decimal(integer_part, decimal_part).to_f
    end

    # Validates if the number is a numeric one.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is a number
    def valid?(attribute, value)
      value.is_a?(Numeric)
    end
  end
end
