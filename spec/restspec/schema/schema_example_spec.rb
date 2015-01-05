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

  describe 'root cases' do
    let(:schema_example) { SchemaExample.new(schema) }

    context 'with a schema that root? with a value' do
      let(:schema) { Schema.new(:dog, root: 'monkey') }

      it 'generates an example wrapped in the root value' do
        expect(schema_example.value).to have_key(:monkey)
        expect(schema_example.value[:monkey]).to have_key(:name)
        expect(schema_example.value[:monkey]).to have_key(:age)
      end
    end

    context 'with a schema that root? with true' do
      let(:schema) { Schema.new(:dog, root: true) }

      it 'generates an example wrapped in the schema name' do
        expect(schema_example.value).to have_key(:dog)
      end
    end
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
