require 'spec_helper'

include Restspec::Schema::Types

describe BasicType do
  let(:subclass) do
    Class.new(BasicType) do
      def valid?(attribute, value); true; end
    end
  end

  let(:type) { subclass.new }
  let(:attribute) { double }
  let(:value) { double }

  describe '|' do
    let(:other_type) { subclass.new }

    before do
      type | other_type
    end

    it 'makes totally_valid? to answer true if the type is valid' do
      allow(type).to receive(:valid?).and_return(true)
      expect(type.totally_valid?(attribute, value)).to eq(true)
    end

    it 'makes totally_valid? to answer true if the type is invalid but the other is valid' do
      allow(type).to receive(:valid?).and_return(false)
      allow(other_type).to receive(:valid?).and_return(true)
      expect(type.totally_valid?(attribute, value)).to eq(true)
    end

    it 'makes totally_valid? to answer false if both of them are invalid' do
      allow(type).to receive(:valid?).and_return(false)
      allow(other_type).to receive(:valid?).and_return(false)
      expect(type.totally_valid?(attribute, value)).to eq(false)
    end
  end

  describe 'of' do
    let(:other_type) { subclass.new }

    let(:subclass) do
      Class.new(BasicType) do
        def valid?(attribute, value)
          parameterized_type.valid?('attribute', 'value')
        end
      end
    end

    before do
      type.of(other_type)
    end

    it 'makes valid? to use the other type as his parameterized_type' do
      allow(other_type).to receive(:valid?).and_return(true)
      type.valid?(attribute, value)
      expect(other_type).to have_received(:valid?).with('attribute', 'value')
    end
  end
end
