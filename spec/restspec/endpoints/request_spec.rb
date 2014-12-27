require 'spec_helper'

include Restspec::Endpoints

describe Request do
  let(:request) do
    Request.new(:get, '/url', {'header' => 'header'}, {'payload' => 'payload'})
  end

  it 'is a bag for request data' do
    expect(request.method).to eq(:get)
    expect(request.url).to eq('/url')
    expect(request.headers).to eq({'header' => 'header'})
    expect(request.payload).to eq({'payload' => 'payload'})
  end

  describe '#endpoint=' do
    let(:endpoint) { double }

    it 'injects an endpoint' do
      request.endpoint = endpoint
      expect(request.endpoint).to eq(endpoint)
    end
  end

  describe '#raw_payload' do
    it 'is the raw payload to send through the wire json encoded' do
      request.payload = { 'hola' => 'mundo' }
      expect(JSON.parse(request.raw_payload)).to eq(request.payload)
    end
  end
end

