require 'spec_helper'

describe Restspec::Endpoints::DSL do
  let(:dsl) { Restspec::Endpoints::DSL.new }

  before do
    Restspec::NamespaceStore.clear
    Restspec::EndpointStore.clear
  end

  describe '#namespace' do
    it 'creates a namespace' do
      expect do
        dsl.namespace(:monkey) { }
      end.to change { Restspec::NamespaceStore.size }.by(1)
    end

    it 'creates a namespace with the given name as a string' do
      dsl.namespace(:monkey) { }
      expect(Restspec::NamespaceStore.get(:monkey).name).to eq('monkey')
    end

    it 'creates a namespace with the given base_path' do
      dsl.namespace(:monkey, base_path: '/monkey') { }
      expect(Restspec::NamespaceStore.get(:monkey).full_base_path).to eq('/monkey')
    end

    it 'yields a Restspec::Endpoints::NamespaceDSL attached to the namespace to the block' do
      namespace_dsl = OpenStruct.new(call: true)

      allow(namespace_dsl).to receive(:call).and_return(true)
      allow(Restspec::Endpoints::NamespaceDSL).to receive(:new) do |namespace|
        namespace_dsl.namespace = namespace
        namespace_dsl
      end

      dsl.namespace(:monkey) do
        self.call
      end

      expect(namespace_dsl).to have_received(:call)
      expect(namespace_dsl.namespace).to eq(Restspec::NamespaceStore.get(:monkey))
    end
  end

  describe '#resource' do
    before do
      schema = Restspec::Schema::Schema.new(:monkey)
      Restspec::SchemaStore.store(schema)
    end

    it 'creates a namespace with the base_path equals to /:name' do
      dsl.resource(:monkeys) { }
      expect(Restspec::NamespaceStore.get(:monkeys).full_base_path).to eq('/monkeys')
    end

    it 'creates a namespace with the schema attached to some schema with the same name' do
      dsl.resource(:monkeys) { }
      expect(Restspec::NamespaceStore.get(:monkeys).schema_for(:response).name).to eq(:monkey)
    end
  end

  describe Restspec::Endpoints::NamespaceDSL do
    let(:namespace) { Restspec::Endpoints::Namespace.new(:monkeys) }
    let(:ns_dsl) { Restspec::Endpoints::NamespaceDSL.new(namespace) }

    describe '#endpoint' do
      it 'creates an endpoint for the namespace' do
        expect do
          ns_dsl.endpoint(:show) { }
        end.to change { Restspec::EndpointStore.size }.by(1)
      end

      it 'creates an endpoint with the full name of the endpoint' do
        ns_dsl.endpoint(:show) { }
        expect(Restspec::EndpointStore.get("monkeys/show")).to be_present
      end
    end

    describe 'HTTP_METHODS calls' do
      Restspec::Endpoints::HTTP_METHODS.each do |http_method|
        describe "##{http_method}" do
          it "creates an endpoint with the method set to #{http_method} and the correct path" do
            ns_dsl.send(http_method, :show, '/hola')
            endpoint = Restspec::EndpointStore.get("monkeys/show")
            expect(endpoint.method).to eq(http_method)
            expect(endpoint.path).to eq('/hola')
          end
        end
      end
    end

    describe '#schema' do
      before do
        Restspec::SchemaStore.store(Restspec::Schema::Schema.new(:schema_name))
      end

      it 'sets the schema_name of the namespace' do
        expect do
          ns_dsl.schema :schema_name
        end.to change { namespace.schema_for(:response).try(:name) }.to(:schema_name)
      end
    end

    describe '#all' do
      before do
        Restspec::SchemaStore.store(Restspec::Schema::Schema.new(:a_schema_name))
      end

      it 'calls the same block in all the endpoints inside' do
        ns_dsl.all do
          schema :a_schema_name
        end

        ns_dsl.endpoint(:a) { }
        ns_dsl.endpoint(:b) { }

        endpoint_a = Restspec::EndpointStore.get('monkeys/a')
        endpoint_b = Restspec::EndpointStore.get('monkeys/b')

        expect(endpoint_a.schema_for(:response).name).to eq(:a_schema_name)
        expect(endpoint_a.schema_for(:response).name).to eq(:a_schema_name)
      end
    end

    describe '#url_param' do
      it 'sets the url_params in each endpoint' do
        ns_dsl.url_param(:param) { 'value' }

        ns_dsl.endpoint(:a) { }
        ns_dsl.endpoint(:b) { }

        Restspec::EndpointStore.each do |_, endpoint|
          expect(endpoint.url_params[:param]).to eq('value')
        end
      end
    end

    describe 'resource sub-methods' do
      let(:namespace) do
        dsl.resource(:monkeys) { }
        Restspec::NamespaceStore.get(:monkeys)
      end

      shared_examples :anonymous_namespace_method do |method_name|
        it 'does not adds itself to the NamespaceStore' do
          expect do
            ns_dsl.send(method_name) { }
          end.to_not change { Restspec::EndpointStore.size }
        end

        it 'creates a namespace inside the parent namespace' do
          expect do
            ns_dsl.send(method_name) { }
          end.to change { namespace.children_namespaces.size }.by(1)
        end

        it 'creates an anonymous namespace' do
          ns_dsl.send(method_name) { }
          expect(namespace.children_namespaces.first).to be_anonymous
        end
      end

      describe '#member' do
        it 'adds a namespace that attaches the namespace parent base_path and the /:id path to the endpoints inside' do
          ns_dsl.member do
            endpoint(:a) { }
            endpoint(:b) { path '/home' }
          end

          expect(Restspec::EndpointStore.get("monkeys/a").full_path).to eq('/monkeys/:id')
          expect(Restspec::EndpointStore.get("monkeys/b").full_path).to eq('/monkeys/:id/home')
        end

        it_behaves_like :anonymous_namespace_method, :member
      end

      describe '#collection' do
        it 'adds a namespace that attaches the previous base_path to the current path' do
          ns_dsl.collection do
            endpoint(:a) { }
            endpoint(:b) { path '/home' }
          end

          expect(Restspec::EndpointStore.get("monkeys/a").full_path).to eq('/monkeys')
          expect(Restspec::EndpointStore.get("monkeys/b").full_path).to eq('/monkeys/home')
        end

        it_behaves_like :anonymous_namespace_method, :collection
      end
    end
  end

  describe Restspec::Endpoints::EndpointDSL do
    let(:endpoint) { Restspec::Endpoints::Endpoint.new }
    let(:endpoint_dsl) { Restspec::Endpoints::EndpointDSL.new(endpoint) }

    describe '#method' do
      it 'sets the method of the endpoint' do
        expect { endpoint_dsl.method :get }.to change { endpoint.method }.to(:get)
      end
    end

    describe '#path' do
      it 'sets the path of the endpoint' do
        expect {
          endpoint_dsl.path '/hola'
        }.to change { endpoint.full_path }.from(nil).to('/hola')
      end
    end

    describe '#schema' do
      it 'sets the schema for response' do
        expect {
          endpoint_dsl.schema :monkey
        }.to change { endpoint.schema_for(:response).try(:name) }.from(nil).to(:monkey)
      end
    end

    describe '#headers' do
      it 'changes the headers of the endpoint' do
        expect do
          endpoint_dsl.headers['hola'] = 'mundo'
        end.to change { endpoint.headers['hola'] }.from(nil).to('mundo')
      end
    end

    describe '#url_param' do
      context 'with a block returning a raw value' do
        it 'adds the raw param to the endpoint' do
          endpoint_dsl.url_param(:param) { 'param' }
          expect(endpoint.url_params).to have_key(:param)
          expect(endpoint.url_params[:param]).to eq('param')
        end
      end

      context 'with a block returning a schema type' do
        let(:type) { Restspec::Schema::Types::StringType.new }

        before do
          allow(type).to receive(:example_for).and_return('')
        end

        it 'executes example_for in the type' do
          type = self.type

          endpoint_dsl.url_param(:param) { type }
          found_param = endpoint.url_params[:param]

          expect(type).to have_received(:example_for)
          expect(found_param).to eq('')
        end

        context 'when the endpoint has a schema' do
          let(:schema) { double(attributes: { param: 1 }) }

          before do
            allow(endpoint).to receive(:schema_for).and_return(schema)
          end

          it 'calls the example_for with the attribute from the schema' do
            type = self.type

            endpoint_dsl.url_param(:param) { type }
            found_param = endpoint.url_params[:param]

            expect(type).to have_received(:example_for).with(1)
          end
        end
      end
    end
  end
end

