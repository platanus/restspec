require 'spec_helper'

include Restspec::Endpoints
SuperHash = Restspec::Values::SuperHash

describe Response do
  let(:response) { Response.new(200, {}, body) }

  describe '#read_body' do
    subject { response.read_body }

    context 'when the body is a scalar' do
      let(:body) { 'Hello' }
      it { should be_kind_of(String) }
      it { should eq(body) }
    end

    context 'when the body is a hash of scalar values' do
      let(:body) { { x: 1, y: 'string', z: true }.to_json }
      it { should be_kind_of(SuperHash) }
    end

    context 'when the body is an array of scalar values' do
      let(:info) { [1, 'string', true] }
      let(:body) { info.to_json }
      it { should be_kind_of(Array) }
      it { should eq(info) }
    end

    context 'when the body is an array of hashes' do
      let(:info) { [{x: 1}, {x: 2}, {x: 3}] }
      let(:body) { info.to_json }
      it { should be_kind_of(Array) }
      it { should eq(info.as_json) }
    end

    context 'when the body is a hash of array elements' do
      let(:body) { { animals: [ { name: 'Lion' }, { name: 'Elephant' } ], number_of_animals: 2 }.to_json }
      it { should be_kind_of(SuperHash) }
      it { should have_key(:animals) }

      it 'includes an array of SuperHashes' do
        subject.animals.each do |animal|
          expect(animal).to be_kind_of(SuperHash)
        end
      end
    end
  end
end
