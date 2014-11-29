require 'spec_helper'

include Restspec::Schema::Types

describe StringType do
  let(:attribute) { double }
  let(:type) { StringType.new }

  describe '#valid?' do
    it 'only allows strings' do
      expect(type.valid?(attribute, true)).to eq(false)
      expect(type.valid?(attribute, false)).to eq(false)
      expect(type.valid?(attribute, 1)).to eq(false)
      expect(type.valid?(attribute, 1.5)).to eq(false)
      expect(type.valid?(attribute, 'string')).to eq(true)
    end
  end

  describe '#example_for' do
    it 'generates a string' do
      10.times.map {
        expect(type.example_for(attribute)).to be_kind_of(String)
      }
    end
  end
end
