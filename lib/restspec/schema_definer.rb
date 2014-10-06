require_relative './schema/checker'
require_relative './schema/attribute'
require_relative './schema/attribute_example'
require_relative './schema/schema_example'
require_relative './schema/schema'
require_relative './schema/dsl'

module Restspec
  def self.define_schemas(&block)
    @dsl = Schema::DSL.new
    @dsl.instance_eval(&block)
  end

  def self.schemas
    @dsl ? @dsl.schemas : {}
  end

  def self.dsl
    @dsl
  end

  def self.find_schema(schema_name)
    schemas.fetch(schema_name)
  end

  def self.example_for(schema_name)
    schema = Restspec.find_schema(schema_name)
    if schema
      Schema::SchemaExample.new(schema).value
    else
      raise "Unexisting schema: #{schema_name}"
    end
  end
end
