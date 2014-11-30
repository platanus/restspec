require 'spec_helper'

include Restspec::Schema

describe DSL do
  let(:dsl) { DSL.new }

  describe '#schema' do
    let(:single_dsl) { double }
    let(:schema) { double(name: 'name') }

    before do
      allow(SingleSchemaDSL).to receive(:new).and_return(single_dsl)
      allow(single_dsl).to receive(:instance_eval).and_return(single_dsl)
      allow(single_dsl).to receive(:schema).and_return(schema)
    end

    it 'creates a SingleSchemaDSL with the given name' do
      dsl.schema('name') { }
      expect(SingleSchemaDSL).to have_received(:new)
    end

    it 'store the schema into the SchemaStore' do
      dsl.schema('name') { }
      expect(Restspec::SchemaStore.get('name')).to be_present
    end
  end
end

describe SingleSchemaDSL do
  let(:dsl) { SingleSchemaDSL.new(name) }
  let(:name) { 'name' }

  describe '#initialize' do
    it 'makes the dsl to return a schema with the given name' do
      expect(dsl.schema.name).to eq(name)
    end
  end

  describe '#attribute' do
    let(:type_instance) { dsl.string }

    it 'creates an attribute with name, type and options' do
      dsl.attribute('attr_name', type_instance, {})

      expect(dsl.schema.attributes.size).to eq(1)
      attribute = dsl.schema.attributes[0]
      if attribute.present?
        expect(attribute.name).to eq('attr_name')
        expect(attribute.type).to eq(type_instance)
        expect(attribute.options).to eq({})
      end
    end
  end
end
