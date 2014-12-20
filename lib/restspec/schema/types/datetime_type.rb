module Restspec::Schema::Types
  class DateTimeType < BasicType
    def example_for(attribute)
      Faker::Time.between(initial_example_interval, final_example_interval).iso8601
    end

    def valid?(attribute, value)
      return false unless value.present?
      DateTime.parse(value).strftime(date_time_format) == value
    rescue ArgumentError
      false
    end

    private

    def date_time_format
      schema_options.fetch(:format, '%Y-%m-%dT%H:%M:%S.%LZ')
    end

    def initial_example_interval
      example_options.fetch(:initial_interval, 1.month.ago)
    end

    def final_example_interval
      example_options.fetch(:final_interval, Time.now)
    end
  end
end
