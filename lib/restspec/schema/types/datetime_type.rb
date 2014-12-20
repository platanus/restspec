module Restspec::Schema::Types
  class DateTimeType < BasicType
    def example_for(attribute)
      Faker::Time.between(initial_example_interval, final_example_interval).iso8601
    end

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
