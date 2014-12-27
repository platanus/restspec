module Restspec::Schema::Types
  # Manages DateTime
  #
  # Options:
  #   Example:
  #     initial_interval: The initial interval (default: 2 months ago)
  #     final_interval: The final interval (default: `Time.now`)
  class DateTimeType < BasicType
    # Generates an example time formatted as ISO8601.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @return [string] A time between 1 month ago and now formatted as ISO8601.
    def example_for(attribute)
      Faker::Time.between(initial_example_interval, final_example_interval).iso8601
    end

    # Validates is the value is a correct time according to ISO8601.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is accord to ISO8601.
    def valid?(attribute, value)
      return false unless value.present?
      allowed_date_time_formats.any? do |format|
        DateTime.parse(value).strftime(format) == value
      end
    rescue ArgumentError
      false
    end

    private

    def allowed_date_time_formats
      ['%Y-%m-%dT%H:%M:%S.%LZ', '%Y-%m-%dT%H:%M:%S%Z']
    end

    def initial_example_interval
      example_options.fetch(:initial_interval, 1.month.ago)
    end

    def final_example_interval
      example_options.fetch(:final_interval, Time.now)
    end
  end
end
