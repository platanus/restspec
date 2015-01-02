module Restspec::Schema::Types
  module TypeMethods
    # @private
    # @!macro type_method
    #   @!method $1(options = {})
    #
    #   Creates a new {$2} instance with the first argument
    #   passed as parameter to the {$2} constructor.
    #
    #   @param options [Hash, Object] A hash of options or
    #     something to instantiate the type.
    def self.define_type_method(method_name, type_class)
      define_method(method_name) do |*args|
        type_class.new(*args)
      end
    end

    define_type_method :string, StringType
    define_type_method :integer, IntegerType
    define_type_method :decimal, DecimalType
    define_type_method :boolean, BooleanType
    define_type_method :decimal_string, DecimalStringType
    define_type_method :schema_id, SchemaIdType
    define_type_method :array, ArrayType
    define_type_method :one_of, OneOfType
    define_type_method :hash, HashType
    define_type_method :null, NullType
    define_type_method :embedded_schema, EmbeddedSchemaType
    define_type_method :date, DateType
    define_type_method :datetime, DateTimeType
  end
end
