require_relative './schema/checker'
require_relative './schema/attribute'
require_relative './schema/attribute_example'
require_relative './schema/schema_example'
require_relative './schema/schema'
require_relative './schema/dsl'
require_relative './schema/finder'

module Restspec
  class << self
    attr_reader :dsl

    def define_schemas(&block)
      self.dsl = Schema::DSL.new
      self.dsl.instance_eval(&block)
    end

    def example_for(schema_name)
      schema = Restspec::Schema::Finder.new.find(schema_name)
      Schema::SchemaExample.new(schema).value
    end

    private

    attr_writer :dsl
  end
end
