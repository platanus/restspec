module Restspec::Schema::Types
  class BooleanType < BasicType
    def example_for(attribute)
      [true, false].sample
    end

    def valid?(attribute, value)
      [true, false].include?(value)
    end
  end
end
