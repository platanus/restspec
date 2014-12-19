module Restspec::Schema::Types
  class DateType < BasicType
    DATE_FORMAT = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/

    def example_for(attribute)
      Faker::Date.between(1.month.ago, Date.today).to_s
    end

    def valid?(attribute, value)
      return false unless value.present?
      return false unless value.match(DATE_FORMAT).present?
      year, month, day = value.split('-').map &:to_i
      Date.valid_date?(year, month, day)
    end
  end
end
