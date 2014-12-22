require 'spec_helper'

describe Restspec::Schema::Schema do
  Schema = Restspec::Schema::Schema

  it 'is only a bag for name and attributes that by default is a hash' do
    person_schema = Schema.new(:person)
    expect(person_schema.attributes).to eq({})
    expect(person_schema.name).to eq(:person)
  end

  describe '#extend_with' do
    let(:schema) { Schema.new(:person) }

    before do
      schema.attributes['attribute'] = 'Attribute'
    end

    context 'using :without' do
      it 'removes an attribute' do
        schema.extend_with(without: ['attribute'])
        expect(schema.attributes).to_not have_key('attribute')
      end
    end
  end
end
