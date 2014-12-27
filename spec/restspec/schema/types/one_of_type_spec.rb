require 'spec_helper'

include Restspec::Schema::Types

describe OneOfType do
  let(:type) { OneOfType.new(elements: [1, 2, 3]) }

  describe '#example_for' do
    it 'returns one example of the elements array' do
      expect([1, 2, 3]).to include(type.example_for(double))
    end
  end

  describe '#valid' do
    it 'checks if the value is one of the elements array' do
      expect(type.totally_valid?(double, 1)).to eq(true)
      expect(type.totally_valid?(double, nil)).to eq(false)
      expect(type.totally_valid?(double, '1')).to eq(false)
    end
  end
end
