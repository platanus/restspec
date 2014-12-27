require 'spec_helper'

include Restspec::Stores

describe "EndpointStore" do
  let(:endpoint) { OpenStruct.new(:full_name => :name) }

  before do
    EndpointStore.clear
  end

  describe '#store' do
    it 'stores the endpoint in a key hash called name' do
      EndpointStore.store(endpoint)
      expect(EndpointStore.get(:name)).to eq(endpoint)
    end
  end

  describe '#get_by_schema_and_name' do
    let(:endpoint_1) do
      OpenStruct.new(:full_name => :name_1, :schema_name => :schema_name_1, :name => :name_1)
    end

    let(:endpoint_2) do
      OpenStruct.new(:full_name => :name_2, :schema_name => :schema_name_2, :name => :name_2)
    end

    before do
      EndpointStore.store(endpoint_1)
      EndpointStore.store(endpoint_2)
    end

    context 'without something with the same schema' do
      let(:found_endpoint) { EndpointStore.get_by_schema_and_name(:schema_name_1, :name_2) }

      it 'is nil' do
        expect(found_endpoint).to be_nil
      end
    end

    context 'with something with the same schema and name' do
      let(:found_endpoint) { EndpointStore.get_by_schema_and_name(:schema_name_1, :name_1) }

      it 'is the correct endpoint' do
        expect(found_endpoint).to eq(endpoint_1)
      end
    end
  end
end
