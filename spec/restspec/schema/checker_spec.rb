require 'spec_helper'

include Restspec::Schema

describe Checker do
  let(:options) { {} }
  let(:schema) do
    Schema.new(:product, options).tap do |schema|
      schema.attributes[:name] = Attribute.new(:name, Types::StringType.new)
    end
  end

  let(:checker) { Checker.new(schema) }

  describe '#check!' do
    context 'when no object is sent' do
      it 'raises a Checker::NoObjectError' do
        expect do
          checker.check!(nil)
        end.to raise_error(Checker::NoObjectError, /Nil/)
      end
    end

    context 'when the schema is root?' do
      let(:options) { { root: 'monkey' } }

      context 'when no root is present' do
        it 'raises a Checker::NoRootFoundError' do
          expect do
            checker.check!(age: 10)
          end.to raise_error(Checker::NoRootFoundError, /monkey/)
        end
      end

      context 'when the root is present' do
        it 'does not raises a Checker::NoRootFoundError' do
          expect do
            checker.check!(monkey: { name: 'Apu' })
          end.to_not raise_error
        end
      end
    end

    context 'when no attribute is present' do
      it 'raises a Checker::NoAttributeError' do
        expect do
          checker.check!(age: 10)
        end.to raise_error(Checker::NoAttributeError, /name/)
      end
    end

    context 'when the attribute is not valid' do
      it 'raises a Checker::InvalidationError' do
        expect do
          checker.check!(name: 10)
        end.to raise_error(Checker::InvalidationError, /string/)
      end
    end

    context 'when the attribute is present and valid' do
      it 'does not raises any error' do
        expect do
          checker.check!(name: 'John')
        end.to_not raise_error
      end
    end
  end

  describe '#check_array!' do
    let(:array) { [1, 2, 3] }

    it 'calls #check! with every item of the array' do
      allow(checker).to receive(:check!).and_return(true)
      checker.check_array!(array)
      expect(checker).to have_received(:check!).exactly(3).times
    end
  end
end
