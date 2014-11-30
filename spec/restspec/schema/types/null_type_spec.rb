require 'spec_helper'

include Restspec::Schema::Types

describe NullType do
  describe '#example_for' do
    subject { NullType.new.example_for(double) }

    it { should eq(nil) }
  end

  describe 'valid?' do
    let(:type) { NullType.new }

    it 'only is true when nil' do
      expect(type.valid?(double, nil)).to eq(true)
      expect(type.valid?(double, false)).to eq(false)
      expect(type.valid?(double, '')).to eq(false)
      expect(type.valid?(double, 'hola')).to eq(false)
      expect(type.valid?(double, 'null')).to eq(false)
      expect(type.valid?(double, 0)).to eq(false)
      expect(type.valid?(double, 1)).to eq(false)
    end
  end
end
