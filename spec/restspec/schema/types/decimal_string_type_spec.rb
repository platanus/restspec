require 'spec_helper'

include Restspec::Schema::Types

describe DecimalStringType do
  let(:options) { {} }
  let(:type) { DecimalStringType.new options }

  describe '#example_for' do
    it 'generates a random number wrapped in a string' do
      10.times do
        sample = type.example_for(double)
        expect(sample).to respond_to(:to_f)
      end
    end
  end

  describe '#valid?' do
    context 'without integer_part or decimal_part options' do
      it 'will validate against any decimal string' do
        expect(type.totally_valid?(double, '0.1001019')).to eq(true)
        expect(type.totally_valid?(double, '9992329323.9')).to eq(true)
        expect(type.totally_valid?(double, '9992329323.0')).to eq(true)
        expect(type.totally_valid?(double, '9992329323')).to eq(true)
        expect(type.totally_valid?(double, 'mono')).to eq(false)
        expect(type.totally_valid?(double, '')).to eq(false)
        expect(type.totally_valid?(double, 199.99)).to eq(false)
      end
    end

    context 'with integer part and decimal part options' do
      context 'with 2,2' do
        let(:options) { { schema_options: { integer_part: 2, decimal_part: 2 } } }

        it 'will validate only against strings with two integer parts and two decimal parts' do
          expect(type.totally_valid?(double, '2.22')).to eq(true)
          expect(type.totally_valid?(double, '22.22')).to eq(true)
          expect(type.totally_valid?(double, '222.22')).to eq(false)
          expect(type.totally_valid?(double, '22.221')).to eq(false)
        end
      end

      context 'with 2,0' do
        let(:options) { { schema_options: { integer_part: 2, decimal_part: 0 } } }

        it 'will validate only against strings with two integer parts and 0 decimal parts' do
          expect(type.totally_valid?(double, '2')).to eq(true)
          expect(type.totally_valid?(double, '22')).to eq(true)
          expect(type.totally_valid?(double, '222.22')).to eq(false)
          expect(type.totally_valid?(double, '22.2')).to eq(false)
        end
      end
    end
  end
end

