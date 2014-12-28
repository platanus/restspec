require 'spec_helper'

include Restspec::Schema

describe Attribute do
  let(:type) { double }

  describe '#example' do
    let(:example) { 'example' }
    let(:attribute) { Attribute.new(:name, type, example: example) }

    it 'returns the example option' do
      expect(attribute.example).to eq(example)
    end
  end

  describe '#can_be_checked?' do
    subject { attribute.can_be_checked? }

    context 'without the option' do
      let(:attribute) { Attribute.new(:name, type, :for => []) }
      it { should eq(false) }
    end

    context 'with the option' do
      let(:attribute) { Attribute.new(:name, type, :for => [:payload]) }
      it { should eq(true) }
    end
  end
end
