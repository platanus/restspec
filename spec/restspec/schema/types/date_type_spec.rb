require 'spec_helper'

include Restspec::Schema::Types

describe DateType do
  let(:type) { DateType.new }
  let(:attribute) { double }

  describe '#example_for' do
    it 'returns a valid date' do
      expect(type.example_for(attribute).match(DateType::DATE_FORMAT)).to be_present
    end
  end

  describe '#valid?' do
    it 'validates dates in the ISO 8601 format' do
      expect(type.valid?(attribute, '2014-12-19')).to eq(true)
      expect(type.valid?(attribute, '2014/12/19')).to eq(false)
      expect(type.valid?(attribute, '2014-12-19 01:31:10')).to eq(false)
      expect(type.valid?(attribute, '20141219')).to eq(false)
      expect(type.valid?(attribute, '2014-19-12')).to eq(false)
      expect(type.valid?(attribute, '19-12-2014')).to eq(false)
      expect(type.valid?(attribute, '12-19-2014')).to eq(false)
      expect(type.valid?(attribute, '19/12/2014')).to eq(false)
    end
  end
end
