require 'rspec/expectations'
require 'rack'

def numeric_status_code(status_code)
  if status_code.is_a?(Symbol)
    Rack::Utils::SYMBOL_TO_STATUS_CODE.fetch(status_code)
  else
    status_code
  end
end

RSpec::Matchers.define :have_status do |status_code|
  match do |response|
    response.code == numeric_status_code(status_code)
  end

  failure_message do |actual|
    status_code = numeric_status_code(expected)
    "expected that the status code was #{status_code} but it was #{actual.code}"
  end

  failure_message_when_negated do |actual|
    status_code = numeric_status_code(expected)
    "expected that the status code wasn't #{status_code} but it was #{actual.code}"
  end
end
