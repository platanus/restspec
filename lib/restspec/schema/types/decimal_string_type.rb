module Restspec::Schema::Types
  class DecimalStringType < BasicType
    def example_for(attribute)
      integer_part = example_options.fetch(:integer_part, 2)
      decimal_part = example_options.fetch(:decimal_part, 2)

      Faker::Number.decimal(integer_part, decimal_part).to_s
    end

    def valid?(attribute, value)
      return false unless value.is_a?(String)
      decimal_regex.match(value).present?
    end

    private

    def decimal_regex
      @decimal_regex ||= build_regex
    end

    def build_regex
      integer_part_limit = to_regexp_limit(schema_options.fetch(:integer_part, nil))
      decimal_part_limit = to_regexp_limit(schema_options.fetch(:decimal_part, nil))
      /^\d#{integer_part_limit}([.,]\d#{decimal_part_limit})?$/
    end

    def to_regexp_limit(limit, default = '+')
      if limit.nil?
        default
      else
        "{#{limit}}"
      end
    end
  end
end
