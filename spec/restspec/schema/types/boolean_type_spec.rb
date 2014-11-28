require 'spec_helper'

include Restspec::Schema::Types

describe BooleanType do
  let(:type) { BooleanType.new }
  let(:attribute) { double }

  describe '#example_for' do
    it 'returns true or false' do
      expect([true, false]).to include(type.example_for(attribute))
    end
  end

  describe '#valid?' do
    it 'only validates boolean values' do
      expect(type.valid?(attribute, true)).to eq(true)
      expect(type.valid?(attribute, false)).to eq(true)
      expect(type.valid?(attribute, 'true')).to eq(false)
      expect(type.valid?(attribute, '1')).to eq(false)
      expect(type.valid?(attribute, 'on')).to eq(false)
      expect(type.valid?(attribute, 'yes')).to eq(false)
      expect(type.valid?(attribute, 1)).to eq(false)
    end
  end
end
