module Restspec
  class << self
    attr_reader :schema_dsl, :endpoints_dsl

    def define_schemas(&block)
      self.schema_dsl = Schema::DSL.new
      self.schema_dsl.instance_eval(&block)
    end

    def define_endpoints(&block)
      self.endpoints_dsl = Endpoints::DSL.new
      self.endpoints_dsl.instance_eval(&block)
    end

    def example_for(schema_name)
      schema = Restspec::Schema::Finder.new.find(schema_name)
      Schema::SchemaExample.new(schema).value
    end

    private

    attr_writer :schema_dsl, :endpoints_dsl
  end
end
