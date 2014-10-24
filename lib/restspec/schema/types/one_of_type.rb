module Restspec::Schema::Types
  class OneOfType < BasicType
    def example_for(attribute)
      elements.sample
    end

    def valid?(attribute, value)
      elements.include?(value)
    end

    def to_s
      "OneOfType(#{elements})"
    end

    private

    def elements
      options.fetch(:elements)
    end
  end
end
