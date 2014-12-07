schema :product do
  attribute :name, string
  attribute :code, string
  attribute :price, decimal | decimal_string
  attribute :category_id, schema_id(:category)
end

schema :category do
  attribute :name, string
end