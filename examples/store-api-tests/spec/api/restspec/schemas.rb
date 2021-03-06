mixin :timestamps do
  attribute :created_at, datetime, :for => [:response]
  attribute :updated_at, datetime, :for => [:response]
end

schema :product do
  include_attributes :timestamps

  attribute :name, string
  attribute :code, string
  attribute :price, decimal | decimal_string
  attribute :category_id, schema_id(:category)
  attribute :category, embedded_schema(:category), :for => [:response]
end

schema :category do
  attribute :name, string
end
