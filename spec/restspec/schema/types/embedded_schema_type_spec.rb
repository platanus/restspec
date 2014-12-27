require 'spec_helper'

include Restspec::Schema::Types

describe EmbeddedSchemaType do
  let(:type) { EmbeddedSchemaType.new(:category) }

  before do
    Restspec::Schema::DSL.new.instance_eval do
      schema :category do
        attribute :name, string
        attribute :description, string
      end
    end
  end

  describe '#example_for' do
    it 'is a example of the embedded schema' do
      sample = type.example_for(double)
      expect(sample[:name]).to be_a_kind_of(String)
    end
  end

  describe '#valid?' do
    it 'is valid if this works with the embedded schema' do
      expect(type.totally_valid?(double, name: 'Name', description: 'Desc')).to eq(true)
      expect(type.totally_valid?(double, name: 'Name')).to eq(false)
      expect(type.totally_valid?(double, age: 10)).to eq(false)
      expect(type.totally_valid?(double, name: 'Name', description: nil)).to eq(false)
    end
  end
end
