module Restspec::Schema::Types
  class DateType < BasicType
    DATE_FORMAT = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/

    # Generates an example date.
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @return [Date] A random date between one month ago and today.
    def example_for(attribute)
      Faker::Date.between(1.month.ago, Date.today).to_s
    end

    # Validates if the value is a date.
    # It basically checks if the date is according
    # to yyyy-mm-dd format
    #
    # @param attribute [Restspec::Schema::Attribute] the atribute of the schema.
    # @param value [Object] the value of the attribute.
    #
    # @return [true, false] If the value is a date with the correct format.
    def valid?(attribute, value)
      return false unless value.present?
      return false unless value.match(DATE_FORMAT).present?
      year, month, day = value.split('-').map &:to_i
      Date.valid_date?(year, month, day)
    end
  end
end
