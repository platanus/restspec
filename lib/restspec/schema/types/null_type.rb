module Restspec::Schema::Types
  class NullType < BasicType
    def example_for(attribute)
      nil
    end

    def valid?(attribute, value)
      value.nil?
    end
  end
end
