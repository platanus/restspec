require 'rspec/expectations'
require 'rack'

RSpec::Matchers.define :have_status do |status_code|
  match do |response|
    response.code == Restspec::Values::StatusCode.new(status_code).value
  end

  failure_message do |response|
    status_code = Restspec::Values::StatusCode.new(expected).value
    "expected #{response} to have status code: #{status_code} but it was #{response.code}"
  end

  failure_message_when_negated do |actual|
    status_code = Restspec::Values::StatusCode.new(expected).value
    "expected #{response} to don't have status code: #{status_code} but it was #{response.code}"
  end
end
