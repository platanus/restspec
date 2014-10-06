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
  schema :category do
    attribute :name, String
    # name String, validate: { presence: true }
    # price Float, validate: { presence: true, numericality: true }
    # category_id Integer, is_one_of: ->{ read_endpoint('categories/index').map_by(:id) }
  end
end
