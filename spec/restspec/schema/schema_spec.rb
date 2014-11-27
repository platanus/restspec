require 'spec_helper'

describe Restspec::Schema::Schema do
  Schema = Restspec::Schema::Schema

  it 'is only a bag for name and attributes that by default is a hash' do
    person_schema = Schema.new(:person)
    expect(person_schema.attributes).to eq({})
    expect(person_schema.name).to eq(:person)
  end
end
