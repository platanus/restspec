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

    it 'creates an attribute with name and type' do
      dsl.attribute('attr_name', type_instance, {})

      expect(dsl.schema.attributes.size).to eq(1)

      attribute = dsl.schema.attributes.values.first

      expect(attribute.name).to eq('attr_name')
      expect(attribute.type).to eq(type_instance)
    end

    context 'when the :for option is just for checks' do
      let(:attribute) { dsl.attribute('attr_name', type_instance, for: [:checks]) }

      it 'is not allowed to generate examples' do
        expect(attribute.can_generate_examples?).to eq(false)
      end

      it 'is allowed to run in validations' do
        expect(attribute.can_be_checked?).to eq(true)
      end
    end

    context 'when the :for option is just for examples' do
      let(:attribute) { dsl.attribute('attr_name', type_instance, for: [:examples]) }

      it 'is allowed to generate examples' do
        expect(attribute.can_generate_examples?).to eq(true)
      end

      it 'is not allowed to run in validations' do
        expect(attribute.can_be_checked?).to eq(false)
      end
    end
  end

  describe '#include_attributes' do
    let(:main_dsl) { DSL.new }
    let(:schema_dsl) { SingleSchemaDSL.new(:name, main_dsl.send(:mixins)) }

    before do
      main_dsl.mixin :test_mixin do
        attribute :test_attribute, string
      end
    end

    it 'includes the attributes to the schema' do
      schema_dsl.include_attributes(:test_mixin)
      expect(schema_dsl.schema.attributes).to have_key('test_attribute')
    end
  end
end
