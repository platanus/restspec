module Restspec::Schema::Types
  class ArrayType < BasicType
    def example_for(attribute)
      length_only_works_with_parameterized_types!

      example_length.times.map do
        parameterized_type.example_for(attribute)
      end
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

    private

    def example_length
      example_options.fetch(:length, 0)
    end

    def length_only_works_with_parameterized_types!
      if example_options.has_key?(:length) && !parameterized_type
        raise "To use the :length option you need to have a parameterized_type or we can't generate the array"
      end
    end
  end
end
