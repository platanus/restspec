# This is the parent class for all the Types used in the schemas definition.
# The two main reasons of the inheritance over simple duck typing are:
#
#   1. To force the usage of `example_options` and `schema_options`, different
#     sets of options for the two cases a type is used. This two methods are only used
#     privately by the subclasses.
#   2. To allow some kind of **'type algebra'**, with the {#|}, {#of} and {#totally_valid?} methods.
class Restspec::Schema::Types::BasicType
  def initialize(options = {})
    self.options = options
  end

  # The disjunction operator (||) is not a method in ruby, so we are using `|`
  # because it looks similar. The important thing about the type disjunction is
  # that, when checking through a type, a value can checks itself against
  # multiple possible types.
  #
  # @example with two types
  #   attribute :name, string | null
  #
  #   attr_type = schema.attributes[:name].type
  #   attr_type.totally_valid?(schema.attributes[:name], 'Hola') # true
  #   attr_type.totally_valid?(schema.attributes[:name], nil) # true
  #   attr_type.totally_valid?(schema.attributes[:name], 10) # false
  #
  # The example works because the type returned by `string | null` is basically
  # just `string` with a disjunction set to `null`. When validating, if the validation
  # fails initially, the disjunction is used as a second source of thuth. Because the
  # disjunction can have disjunctions too, we can test against more than two types.
  #
  # @example with more than two types
  #   attribute :name, string | (null | integer)
  #
  #   attr_type = schema.attributes[:name].type
  #   attr_type.totally_valid?(schema.attributes[:name], 'Hola') # true
  #   attr_type.totally_valid?(schema.attributes[:name], nil) # true
  #   attr_type.totally_valid?(schema.attributes[:name], 10) # true
  #
  # @param other_type [instance of subclass of BasicType] the type to make the disjuction.
  # @return [BasicType] the same object that is used to call the method. (`self`)
  def |(other_type)
    self.disjuction = other_type
    self
  end

  # The only work of `of` is to set a `parameterized_type` attribute
  # on the type. This parameterized type can be used by the type itself to
  # whatever the type wants. The major limitation is that, by now, we only
  # allow one parameterized type. For example, {ArrayType} uses this parameterized
  # type to do this:
  #
  # @example
  #   attribute :codes, array.of(integer)
  #
  # @param other_type [instance of subclass of BasicType] the type to make the
  #   save as the parameterized type.
  # @return [BasicType] the same object that is used to call the method. (`self`)
  def of(other_type)
    self.parameterized_type = other_type
    self
  end

  # This calls the `valid?` method (that is not present in this class but should
  # be present on their children) making sure to fallback to the disjunction if
  # the disjunction is present.
  #
  # @param attribute [Restspec::Schema::Attribute] The attribute to use.
  # @param value [Object] the object that holds the actual value to test against.
  # @return [true, false] If the type is valid with the following attribute and value.
  def totally_valid?(attribute, value)
    if disjuction.present?
      valid?(attribute, value) || disjuction.valid?(attribute, value)
    else
      valid?(attribute, value)
    end
  end

  # @return [String] a string representation of the type. It's basically the
  #   class name without the `Type` postfix underscorized.
  #
  # @example
  #
  #   StringType.new.to_s #=> string
  #   ArrayType.new.to_s #=> array
  #   SchemaIdType.new.to_s #=> schema_id
  def to_s
    self.class.name.demodulize.gsub(/Type$/, "").underscore
  end

  private

  attr_accessor :options, :disjuction, :parameterized_type

  def example_options
    options.fetch(:example_options, options)
  end

  def schema_options
    options.fetch(:schema_options, options)
  end
end
