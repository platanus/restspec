module Restspec
  module Schema
    module Types
    end
  end
end

require_relative './types/basic_type'
require_relative './types/string_type'
require_relative './types/integer_type'
require_relative './types/decimal_type'
require_relative './types/boolean_type'
require_relative './types/decimal_string_type'
require_relative './types/schema_id_type'
require_relative './types/array_type'
require_relative './types/one_of_type'

module Restspec::Schema::Types
  ALL = {
    string: StringType,
    integer: IntegerType,
    decimal: DecimalType,
    boolean: BooleanType,
    decimal_string: DecimalStringType,
    schema_id: SchemaIdType,
    array: ArrayType,
    one_of: OneOfType
  }
end
