require 'spec_helper'

include Restspec::Schema::Types

describe IntegerType do
  let(:type) { IntegerType.new }
  let(:attribute) { double }

  describe '#example_for' do
    it 'returns a number' do
      10.times do
        expect(type.example_for(attribute)).to be_a_kind_of(Fixnum)
      end
    end
  end

  describe '#valid?' do
    it 'only validates integer values' do
      expect(type.valid?(attribute, 1)).to eq(true)
      expect(type.valid?(attribute, -10)).to eq(true)
      expect(type.valid?(attribute, -10.5)).to eq(false)
      expect(type.valid?(attribute, '10.5')).to eq(false)
      expect(type.valid?(attribute, '10')).to eq(false)
      expect(type.valid?(attribute, 'no')).to eq(false)
      expect(type.valid?(attribute, nil)).to eq(false)
    end
  end
end
