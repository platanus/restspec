require 'spec_helper'

include Restspec::Schema

describe SchemaExample do
  let(:schema) { Schema.new(:name) }
  let(:hidden_type) { double(example_for: 'hidden') }
  let(:string_type) { double(example_for: 'name') }
  let(:integer_type) { double(example_for: 18) }

  subject { schema_example.value }

  before do
    schema.attributes['name'] = Attribute.new(:name, string_type)
    schema.attributes['age'] = Attribute.new(:age, integer_type)
  end

  context 'without extensions' do
    let(:schema_example) { SchemaExample.new(schema) }

    it { should eq(name: 'name', age: 18)}

    context 'with an attribute not allowed to generate examples' do
      before do
        schema.attributes['hidden'] = Attribute.new(:hidden, hidden_type, :for => [:checks])
      end

      it 'does not include the hidden attribute' do
        expect(subject).to_not include(:hidden)
      end
    end
  end

  context 'with extensions' do
    let(:extensions) { Hash[age: 21] }
    let(:schema_example) { SchemaExample.new(schema, extensions) }

    it { should eq(name: 'name', age: 21) }
  end
end
