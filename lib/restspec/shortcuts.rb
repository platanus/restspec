module Restspec
  class << self
    def example_for(schema_name, extensions = {})
      schema = Restspec::Schema::Finder.new.find(schema_name)
      Schema::SchemaExample.new(schema, extensions).value
    end
  end
end
