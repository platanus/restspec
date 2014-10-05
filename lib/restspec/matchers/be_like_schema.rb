require 'rspec/expectations'
require 'active_support/core_ext/object'

RSpec::Matchers.define :be_like_schema do |schema_name|
  match do |response|
    schema = Restspec.find_schema(schema_name)
    if schema
      Restspec::SchemaChecker.new(schema).check(response.body)
    else
      raise "Unexisting schema: #{schema_name}"
    end
  end
end
