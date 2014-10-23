schema :category do
  attribute :name, string
end

schema :product do
  custom_decimal_string = decimal_string({
    example_options: {
      integer_part: 5,
      decimal_part: 2
    }
  })

  attribute :name, string
  attribute :price, decimal | custom_decimal_string

  attribute :category_id, schema_id(:category)
end
