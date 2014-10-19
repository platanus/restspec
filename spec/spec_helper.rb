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
  # TODO: Improve this interface with this:
  # config.schema_definition = 'api/api_schemas.rb'
  # config.endpoints_definition = 'api/api_endpoints.rb'
end

current_directory = File.dirname(__FILE__)

Restspec.define_schemas do
  instance_eval(File.read(File.join(current_directory, "api", "api_schemas.rb")))
end

Restspec.define_endpoints do
  instance_eval(File.read(File.join(current_directory, "api", "api_endpoints.rb")))
end
