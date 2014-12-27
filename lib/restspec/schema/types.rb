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
require_relative './types/hash_type'
require_relative './types/null_type'
require_relative './types/embedded_schema_type'
require_relative './types/date_type'
require_relative './types/datetime_type'
require_relative './types/type_methods'
