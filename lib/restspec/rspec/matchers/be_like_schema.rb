RSpec::Matchers.define :be_like_schema do |schema_name|
  match do |response|
    schema = finder.find(schema_name)
    body = response.respond_to?(:body) ? response.body : response
    checker_for(schema).check!(body)
  end

  private

  def finder
    @finder ||= Restspec::Schema::Finder.new
  end

  def checker_for(schema)
    Restspec::Schema::Checker.new(schema)
  end
end
