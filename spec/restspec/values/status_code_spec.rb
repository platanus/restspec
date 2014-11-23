require 'spec_helper'

describe Restspec::Values::StatusCode do
  describe '#value' do
    it 'maps a string to a code' do
      expect(described_class.new(:ok).value).to eq(200)
    end

    it 'just return the same code' do
      expect(described_class.new(200).value).to eq(200)
    end
  end
end
