require 'restspec'

Dir["#{File.dirname __FILE__}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Restspec::RSpec::ApiHelpers, :type => :api
  config.extend Restspec::RSpec::ApiMacros, :type => :api
  config.extend CustomMacros, :type => :api
end

require_relative './api/restspec/restspec_config'
