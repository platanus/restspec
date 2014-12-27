module Restspec::Schema::Types
  class DecimalStringType < DecimalType
    # Generates a example decimal wrapped in a string. See {DecimalType#example_for}
    # for more details of the example generation.
    #
    # @param (see DecimalType#example_for)
    # @return A random decimal number wrapped in a string.
    def example_for(attribute)
      super(attribute).to_s
    end

    # Checks is a value is a string and it contains a decimal number
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is a string containing a decimal number.
    def valid?(attribute, value)
      return false unless value.is_a?(String)
      decimal_regex.match(value).present?
    end

    private

    def decimal_regex
      integer_part_limit = to_regexp_limit(schema_options.fetch(:integer_part, nil))
      decimal_part_limit = to_regexp_limit(schema_options.fetch(:decimal_part, nil))
      /^\d#{integer_part_limit}([.,]\d#{decimal_part_limit})?$/
    end

    def to_regexp_limit(limit, default = '+')
      if limit.nil?
        default
      else
        if limit > 1
          "{1,#{limit}}"
        else
          "{0,#{limit}}"
        end
      end
    end
  end
end
