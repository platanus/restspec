require 'spec_helper'

include Restspec::Schema::Types

describe DecimalType do
  let(:options) { {} }
  let(:type) { DecimalType.new(options) }

  describe '#example_for' do
    it 'generates numbers' do
      10.times do
        expect(type.example_for(double)).to be_kind_of(Numeric)
      end
    end
  end

  describe '#valid?' do
    it 'only validates numbers' do
      expect(type.totally_valid?(double, 100)).to eq(true)
      expect(type.totally_valid?(double, '100')).to eq(false)
      expect(type.totally_valid?(double, 'mono')).to eq(false)
      expect(type.totally_valid?(double, nil)).to eq(false)
    end
  end
end
