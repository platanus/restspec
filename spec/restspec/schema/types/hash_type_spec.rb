require 'spec_helper'

include Restspec::Schema::Types

describe HashType do
  let(:options) { {} }
  let(:type) { HashType.new(options) }

  describe '#example_for' do
    it 'returns an empty hash' do
      expect(type.example_for(double)).to eq({})
    end
  end

  describe '#valid?' do
    it 'validates if it is a hash' do
      expect(type.totally_valid?(double, {a: 1})).to eq(true)
      expect(type.totally_valid?(double, '{a: 1}')).to eq(false)
    end

    context 'with some specified keys' do
      let(:options) { { schema_options: { keys: ['name', 'age'] } } }

      it 'validates if the keys are present' do
        expect(type.totally_valid?(double, { 'name' => 'name', 'age' => 19 })).to eq(true)
        expect(type.totally_valid?(double, { 'name' => 'name', 'number' => 19 })).to eq(false)
      end
    end

    context 'with a specified value_type' do
      let(:options) { { schema_options: { value_type: StringType.new } } }

      it 'validates that the values are of that type' do
        expect(type.totally_valid?(double, { 'a' => '1', 'b' => '2' })).to eq(true)
        expect(type.totally_valid?(double, { 'a' => '1', 'b' => 2 })).to eq(false)
      end
    end
  end
end
