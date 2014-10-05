require 'rspec/expectations'
require 'active_support/core_ext/object'

module Restspec::HeaderTests
  class HaveKeyTest
    def perform(key, headers)
      headers.has_key?(key)
    end
  end

  class EqualsTest < Struct.new(:expected_header_value)
    def perform(key, headers)
      headers.fetch(key) == expected_header_value
    end
  end

  class ContainsTest < Struct.new(:expected_header_part)
    def perform(key, headers)
      headers.fetch(key).include? expected_header_part
    end
  end

  class MatchesTest < Struct.new(:expected_header_regex)
    def perform(key, headers)
      headers.fetch(key).match(expected_header_regex).present?
    end
  end
end

RSpec::Matchers.define :have_header do |key|
  match do |response|
    chained_test.perform(key, response.headers)
  end

  chain :equals do |expected_header_value|
    @chained_test = Restspec::HeaderTests::EqualsTest.new(expected_header_value)
  end

  chain :that_contains do |expected_header_part|
    @chained_test = Restspec::HeaderTests::ContainsTest.new(expected_header_part)
  end

  chain :that_matches do |expected_header_regex|
    @chained_test = Restspec::HeaderTests::MatchesTest.new(expected_header_regex)
  end

  def chained_test
    @chained_test ||= Restspec::HeaderTests::HaveKeyTest.new
  end
end
