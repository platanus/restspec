RSpec::Matchers.define :be_like_schema do |schema_name|
  match do |response|
    schema = Restspec.find_schema(schema_name)
    if schema.present?
      Restspec::Schema::Checker.new(schema).check!(response.body)
    else
      raise "Unexisting schema: #{schema_name}"
    end
  end
end
