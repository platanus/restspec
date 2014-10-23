module Restspec::Schema::Types
  class ArrayType < BasicType
    def example_for(attribute)
      []
    end

    def valid?(attribute, value)
      is_array = value.is_a?(Array)
      if parameterized_type
        is_array && value.all? do |item|
          parameterized_type.totally_valid?(attribute, item)
        end
      else
        is_array
      end
    end
  end
end
