require 'spec_helper'

include Restspec::Schema::Types

describe ArrayType do
  let(:type) { ArrayType.new }
  let(:attribute) { double }

  describe '#example_for' do
    it 'returns an empty array' do
      expect(type.example_for(attribute)).to eq([])
    end

    context 'with the example option: length' do
      let(:type) { ArrayType.new(example_options: { length: 3 }) }

      it 'raises an error asking for a parameterized type' do
        expect { type.example_for(attribute) }.to raise_error
      end

      context 'with a parameterized type' do
        let(:type) { ArrayType.new(example_options: { length: 3 }).of(StringType.new) }
        let(:parameterized_type) { StringType.new }

        it 'returns an array of that length with elements of that type' do
          array = type.example_for(attribute)
          expect(array.size).to eq(3)

          array.each do |item|
            expect(parameterized_type.valid?(attribute, item)).to eq(true)
          end
        end
      end
    end
  end

  describe '#valid?' do
    it 'validates that the value is an array' do
      expect(type.valid?(attribute, [1, 2, 3])).to eq(true)
      expect(type.valid?(attribute, {})).to eq(false)
      expect(type.valid?(attribute, nil)).to eq(false)
      expect(type.valid?(attribute, "string")).to eq(false)
    end

    context 'with a parameterized type' do
      let(:type) { ArrayType.new.of(StringType.new) }

      it 'validates arrays of the parameterized type' do
        expect(type.valid?(attribute, [1, 2, 3])).to eq(false)
        expect(type.valid?(attribute, [])).to eq(true)
        expect(type.valid?(attribute, ['hola', 'mundo'])).to eq(true)
        expect(type.valid?(attribute, ['hola', 1])).to eq(false)
      end
    end
  end
end
