json.array!(@products) do |product|
  json.extract! product, :id, :name, :code, :price, :category_id, :created_at, :updated_at
  json.url product_url(product, format: :json)
end
