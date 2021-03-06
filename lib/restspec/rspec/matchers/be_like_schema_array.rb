RSpec::Matchers.define :be_like_schema_array do |schema_name = nil|
  match do |response|
    schema = if schema_name.present?
      Restspec::SchemaStore.get(schema_name)
    else
      response.endpoint.schema_for(:response)
    end

    body = response.respond_to?(:body) ? response.body : response
    checker_for(schema).check_array!(body)
  end

  private

  def checker_for(schema)
    Restspec::Schema::Checker.new(schema)
  end
end
