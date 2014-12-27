require 'spec_helper'

include Restspec::Endpoints

describe Endpoint do
  let(:endpoint) { Endpoint.new(:endpoint) }
  subject { endpoint }

  describe '#payload' do
    let(:schema) do
      dsl = Restspec::Schema::SingleSchemaDSL.new(:product, {})
      dsl.instance_eval do
        attribute :title, string, example: 'monkey'
      end
      dsl.schema
    end

    before do
      Restspec::SchemaStore.store(schema)
      endpoint.add_schema(schema.name, :for => [:payload])
    end

    it 'is an example for the schema' do
      expect(endpoint.payload).to eq(title: 'monkey')
    end
  end

  describe '#full_name' do
    context 'standalone' do
      its(:full_name) { should eq('endpoint') }
    end

    context 'inside a namespace' do
      before { endpoint.namespace = Namespace.new(:namespace) }
      its(:full_name) { should eq('namespace/endpoint') }
    end
  end

  describe '#execute_once' do
    before do
      allow(endpoint).to receive(:execute).and_return(true)
    end

    let(:body) { double }
    let(:url_params) { double }
    let(:query_params) { double }

    it 'just calls execute once' do
      4.times { endpoint.execute_once }
      expect(endpoint).to have_received(:execute).once
    end

    it 'pass body, url_params and query_params to execute' do
      endpoint.execute_once(body: body, url_params: url_params, query_params: query_params)
      expect(endpoint).to have_received(:execute).with(
        body: body, url_params: url_params, query_params: query_params
      )
    end

    it 'executes :before param before executing' do
      before_lambda = ->{ }
      allow(before_lambda).to receive(:call)
      endpoint.execute_once(before: before_lambda)

      expect(before_lambda).to have_received(:call).ordered
      expect(endpoint).to have_received(:execute).ordered
    end
  end

  describe '#execute' do
    let(:request) { OpenStruct.new }
    let(:response) { OpenStruct.new }

    before do
      endpoint.method = :get
      endpoint.path = '/home'

      allow(Request).to receive(:new).and_return(request)
      allow(Network).to receive(:request).and_return(response)
    end

    it 'tells the Network to request with a Request object containing everything' do
      endpoint.execute
      expect(Request).to have_received(:new).with(:get, '/home', {}, {})
    end
  end

  describe '#url_params' do
    before do
      endpoint.add_url_param_block(:mono) { 'mono' }
      endpoint.add_url_param_block(:xyz) { 'xyz' }
    end

    it 'is the list of execute url param blocks in a hash with string keys' do
      expect(endpoint.url_params).to eq({
        'mono' => 'mono',
        'xyz' => 'xyz'
      })
    end
  end

  describe '#full_path' do
    before { endpoint.path = '/full_path' }

    context 'standalone' do
      its(:full_path) { should eq('/full_path') }
    end

    context 'inside an anonymous namespace (a member or collection block)' do
      let(:top_level_namespace) { Namespace.create('top_level') }
      let(:member_namespace) { top_level_namespace.add_anonymous_children_namespace }

      before do
        top_level_namespace.base_path = '/monkeys'
        member_namespace.base_path = '/:id'
        member_namespace.parent_namespace = top_level_namespace
        endpoint.namespace = member_namespace
      end

      its(:full_path) { should eq('/monkeys/:id/full_path') }
    end
  end
end
