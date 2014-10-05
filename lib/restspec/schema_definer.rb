require 'faker'

module Restspec
  def self.define_schemas(&block)
    @dsl = SchemaDSL.new
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
      schema.example
    else
      raise "Unexisting schema: #{schema_name}"
    end
  end

  class SchemaDSL
    attr_accessor :schemas

    def initialize
      self.schemas = {}
    end

    def schema(schema_name, &schema_definition)
      schema_dsl = SingleSchemaDSL.new(schema_name)
      schema_dsl.instance_eval(&schema_definition)
      schemas[schema_name] = schema_dsl.schema
    end
  end

  class SingleSchemaDSL
    attr_accessor :schema

    def initialize(name)
      self.schema = Schema.new(name)
    end

    def attribute(name, type)
      schema.attributes[name.to_s] = SchemaAttribute.new(name, type)
    end
  end

  class Schema
    attr_accessor :name, :attributes

    def initialize(name)
      self.name = name
      self.attributes = {}
    end

    def example
      attributes.inject({}) do |sample, (name, attribute)|
        attribute_example = ExampleForType.new(attribute.type).example
        sample.merge({
          name => attribute_example
        })
      end
    end
  end

  class SchemaAttribute < Struct.new(:name, :type)
  end

  class ExampleForType < Struct.new(:type)
    def example
      case type
      when String
        Faker::Lorem.word
      end
    end
  end
end
