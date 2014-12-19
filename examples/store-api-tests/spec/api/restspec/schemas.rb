mixin :timestamps do
  attribute :created_at, datetime
  attribute :updated_at, datetime
end

schema :product do
  attribute :name, string
  attribute :code, string
  attribute :price, decimal | decimal_string
  attribute :category_id, schema_id(:category)
  attribute :category, embedded_schema(:category), :for => [:checks]
  include_attributes :timestamps
end

schema :category do
  attribute :name, string
end
