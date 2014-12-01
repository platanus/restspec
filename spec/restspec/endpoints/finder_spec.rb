require 'spec_helper'

include Restspec::Endpoints

describe Finder do
  let(:finder) { Finder.new }
  let(:endpoint_name) { 'endpoint' }

  subject { finder.find(endpoint_name) }

  context 'without endpoints' do
    it { should eq(nil) }
  end

  context 'with endpoints' do
    let(:endpoint) { double(full_name: endpoint_name) }

    before do
      Restspec::EndpointStore.store(endpoint)
    end

    it { should eq(endpoint) }
  end
end
