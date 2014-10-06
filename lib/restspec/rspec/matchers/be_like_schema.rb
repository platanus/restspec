RSpec::Matchers.define :be_like_schema do |schema_name|
  match do |response|
    schema = finder.find(schema_name)
    checker_for(schema).check!(response.body)
  end

  private

  def finder
    @finder ||= Restspec::Schema::Finder.new
  end

  def checker_for(schema)
    Restspec::Schema::Checker.new(schema)
  end
end
