module Restspec::Schema::Types
  class IntegerType < BasicType
    def example_for(attribute)
      Faker::Number.digit
    end

    def valid?(attribute, value)
      value.is_a?(Fixnum)
    end
  end
end
