class Restspec::Schema::Types::BasicType
  def initialize(options = {})
    self.options = options
  end

  def |(other_type)
    self.disjuction = other_type
    self
  end

  def of(other_type)
    self.parameterized_type = other_type
    self
  end

  def totally_valid?(attribute, value)
    if disjuction.present?
      valid?(attribute, value) || disjuction.valid?(attribute, value)
    else
      valid?(attribute, value)
    end
  end

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
