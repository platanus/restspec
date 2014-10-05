require 'restspec'
require 'rspec/its'
require 'rspec/collection_matchers'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Restspec::ApiHelpers, :type => :endpoint
  config.extend Restspec::ApiMacros, :type => :endpoint
end

Restspec.configure do |config|
  config.base_url = 'http://localhost:3000/api/v1'
  config.request.headers['Content-Type'] = 'application/json'
  config.request.headers['Accept'] = 'application/json'
end
