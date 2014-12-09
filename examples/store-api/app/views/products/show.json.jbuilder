json.extract! @product, :id, :name, :code, :price, :created_at, :updated_at, :category_id
json.category do
  json.id @product.category.id
  json.name @product.category.name
end

