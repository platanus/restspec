schema :category do
  attribute :name, string
end

schema :product do
  attribute :name, string
  attribute :price, decimal_string({
    example_options: {
      integer_part: 5,
      decimal_part: 2
    }
  })

  # attribute :category_id, schema_id(:category)

  attribute :category_id, schema_id({
    fetch_endpoint: 'categories/index',
    create_endpoint: 'categories/create'
  })
end
