require 'spec_helper'

include Restspec::Schema

describe SchemaExample do
  let(:schema) { Schema.new(:name) }
  subject { schema_example.value }

  before do
    allow(AttributeExample).to receive(:new).and_return(
      double(value: 'name'),
      double(value: 18)
    )

    schema.attributes['name'] = Attribute.new(:name, Types::StringType, {})
    schema.attributes['age'] = Attribute.new(:age, Types::IntegerType, {})
  end

  context 'without extensions' do
    let(:schema_example) { SchemaExample.new(schema) }

    it { should eq(name: 'name', age: 18)}
  end

  context 'with extensions' do
    let(:extensions) { Hash[age: 21] }
    let(:schema_example) { SchemaExample.new(schema, extensions) }

    it { should eq(name: 'name', age: 21) }
  end
end
