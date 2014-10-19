module Restspec::Schema::Types
  class StringType < BasicType
    def example_for(attribute)
      Faker::Lorem.word
    end

    def valid?(attribute, value)
      value.is_a?(String)
    end
  end
end
