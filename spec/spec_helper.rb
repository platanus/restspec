require 'restspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Restspec::RSpec::ApiHelpers, :type => :endpoint
  config.extend Restspec::RSpec::ApiMacros, :type => :endpoint
end

Restspec.configure do |config|
  config.base_url = 'http://localhost:3000/api/v1'
end

# TODO: Move the schema definition to a custom file
Restspec.define_schemas do
  # type :decimal_string do |value|
  #   value.is_a?(String) && /^\d+([.,]\d+)?$/.match(value).present?
  # end

  schema :category do
    # attribute :name, :string
    attribute :name, String
  end

  schema :product do
    attribute :name, String
    attribute :category_id, Fixnum
    # attribute :name, :string
    # attribute :price, :decimal_string
    # attribute :category_id, :fixnum

    # For Next Iteration (for 422 cases)
    # validates :name, presence: true
    # validates :price, presence: true, numericality: true
    # validates :category_id, inclusion: ->{
    #   read_endpoint('categories/index').map_by(:id)
    # }
  end
end
