Dir["#{File.dirname __FILE__}/support/**/*.rb"].each {|f| require f}

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/docs/'
  add_filter '/pkg/'
  add_filter '/examples/'
  add_filter '/lib/restspec/rspec'
end

require 'restspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

