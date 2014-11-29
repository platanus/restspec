require 'spec_helper'

include Restspec::Schema

describe AttributeExample do
  let(:type) { Types::StringType.new }
  let(:attribute_options) { Hash.new }
  let(:attribute) { Attribute.new(:name, type, attribute_options) }
  let(:attribute_example) { AttributeExample.new(attribute) }

  describe '#value' do
    subject { attribute_example.value }

    context 'when the attribute has an example value specified in him' do
      let(:attribute_options) { { example: 'mono' } }
      it { should eq('mono') }
    end

    context 'when the attribute has an example lambda specified in him' do
      let(:attribute_options) { { example: ->{ 'mono' } } }
      it { should eq('mono') }
    end

    context 'when attribute doesnt have an example option' do
      before { allow(type).to receive(:example_for).and_return('type example') }

      it { should eq('type example') }

      it 'calls the example_for method of the type' do
        subject
        expect(type).to have_received(:example_for).with(attribute)
      end
    end
  end
end
