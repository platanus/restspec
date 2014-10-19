module Restspec::Schema::Types
  class DecimalType < BasicType
    def example_for(attribute)
      Faker::Number.decimal(2)
    end

    def valid?(attribute, value)
      value.is_a?(Numeric)
    end
  end
end
