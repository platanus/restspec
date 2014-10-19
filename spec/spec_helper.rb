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
  config.schema_definition = "#{File.dirname __FILE__}/api/api_schemas.rb"
  config.endpoints_definition = "#{File.dirname __FILE__}/api/api_endpoints.rb"
end
