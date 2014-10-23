class Restspec::Schema::Types::BasicType
  attr_accessor :options

  def initialize(options = {})
    self.options = options
  end

  def example_options
    options.fetch(:example_options, options)
  end

  def schema_options
    options.fetch(:schema_options, options)
  end

  # Type Algebra
  attr_accessor :disjuction

  def |(other_type)
    self.disjuction = other_type
    self
  end

  def totally_valid?(attribute, value)
    if disjuction.present?
      valid?(attribute, value) || disjuction.valid?(attribute, value)
    else
      valid?(attribute, value)
    end
  end
end
