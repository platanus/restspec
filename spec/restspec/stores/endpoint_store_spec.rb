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

  describe '#get_by_schema_name_and_role' do
    before do
      Restspec::SchemaStore.store(Restspec::Schema::Schema.new(:schema_name_1))
      Restspec::SchemaStore.store(Restspec::Schema::Schema.new(:schema_name_2))
    end

    let(:endpoint_1) do
      Restspec::Endpoints::Endpoint.new(:name_1).tap do |endpoint|
        endpoint.add_schema :schema_name_1, :for => [:response]
      end
    end

    let(:endpoint_2) do
      Restspec::Endpoints::Endpoint.new(:name_2).tap do |endpoint|
        endpoint.add_schema :schema_name_2, :for => [:response]
      end
    end

    before do
      EndpointStore.store(endpoint_1)
      EndpointStore.store(endpoint_2)
    end

    context 'without something with the same schema' do
      let(:found_endpoint) do
        EndpointStore.get_by_schema_name_and_role(:schema_name_1, :name_2, :response)
      end

      it 'is nil' do
        expect(found_endpoint).to be_nil
      end
    end

    context 'with something with the same schema and name' do
      let(:found_endpoint) do
        EndpointStore.get_by_schema_name_and_role(:schema_name_1, :name_1, :response)
      end

      it 'is the correct endpoint' do
        expect(found_endpoint).to eq(endpoint_1)
      end
    end
  end
end
