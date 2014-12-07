RSpec::Matchers.define :be_like_schema do |schema_name = nil|
  match do |response|
    schema = if schema_name.present?
      Restspec::SchemaStore.get(schema_name)
    else
      response.endpoint.schema
    end
    
    body = response.respond_to?(:body) ? response.body : response
    checker_for(schema).check!(body)
  end

  private

  def checker_for(schema)
    Restspec::Schema::Checker.new(schema)
  end
end
