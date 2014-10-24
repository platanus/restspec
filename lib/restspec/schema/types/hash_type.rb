module Restspec::Schema::Types
  class HashType < BasicType
    def example_for(attribute)
      {}
    end

    def valid?(attribute, value)
      is_hash = value.is_a?(Hash)
      keys = schema_options.fetch(:keys, [])

      if keys.empty?
        is_hash
      else
        value_type = schema_options.fetch(:value_type, nil)

        is_hash && keys.all? do |key|
          has_key = value.has_key?(key)
          if has_key && value_type
            has_key && value_type.totally_valid?(attribute, value[key])
          end
        end
      end
    end
  end
end
