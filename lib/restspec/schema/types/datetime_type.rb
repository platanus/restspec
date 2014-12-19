module Restspec::Schema::Types
  class DateTimeType < BasicType
    def example_for(attribute)
      Faker::Time.between(1.month.ago, Time.now).iso8601
    end

    def valid?(attribute, value)
      return false unless value.present?
      DateTime.parse(value).iso8601 == value
    rescue ArgumentError
      false
    end
  end
end
