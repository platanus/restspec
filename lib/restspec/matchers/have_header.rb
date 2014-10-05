require 'rspec/expectations'
require 'active_support/core_ext/object'

RSpec::Matchers.define :have_header do |key|
  match do |response|
    headers = response.headers

    if @test_equality
      headers.fetch(key) == @expected_header_value
    elsif @test_contains
      if @expected_header_value.is_a?(Regexp)
        headers.fetch(key).match(@expected_header_value).present?
      else
        headers.fetch(key).include? @expected_header_value
      end
    else
      headers.has_key?(key)
    end
  end

  chain :equals do |expected_header_value|
    @test_equality = true
    @expected_header_value = expected_header_value
  end

  chain :that_contains do |string_or_regex|
    @test_contains = true
    @expected_header_value = string_or_regex
  end
end
