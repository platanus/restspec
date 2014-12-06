require 'spec_helper'

describe Restspec::Endpoints::Finder do
  let(:finder) { Restspec::Endpoints::Finder.new }

  subject { finder.find('endpoint') }

  context 'without endpoints' do
    it { should eq(nil) }
  end

  context 'with endpoints' do
    let(:endpoint) { double(full_name: 'endpoint') }

    before do
      Restspec::EndpointStore.store(endpoint)
    end

    it { should eq(endpoint) }
  end
end
