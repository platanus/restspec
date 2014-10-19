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
end
