module Restspec::Schema::Types
  class DecimalType < BasicType
    def example_for(attribute)
      integer_part = example_options.fetch(:integer_part, 2)
      decimal_part = example_options.fetch(:decimal_part, 2)
      
      Faker::Number.decimal(integer_part, decimal_part)
    end

    def valid?(attribute, value)
      value.is_a?(Numeric)
    end
  end
end
