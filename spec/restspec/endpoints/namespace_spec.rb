require 'spec_helper'

include Restspec::Endpoints

describe Namespace do
  let(:namespace) { Namespace.new(:namespace) }

  describe '.create (and #anonymous?)' do
    it 'stores the namespace in Restspec::NamespaceStore' do
      namespace = Namespace.create(:name)
      expect(Restspec::NamespaceStore.get(:name)).to eq(namespace)
    end

    context 'without arguments' do
      it 'creates an anonymous namespace' do
        namespace = Namespace.create
        expect(namespace).to be_anonymous
      end
    end
  end

  describe '#add_anonymous_children_namespace' do
    it 'adds one object to #children_namespaces' do
      expect { namespace.add_anonymous_children_namespace }.to change {
        namespace.children_namespaces.size
      }.by(1)
    end
  end

  describe '#add_endpoint' do
    let(:endpoint) { OpenStruct.new }

    it 'adds the endpoint to #endpoints' do
      expect { namespace.add_endpoint(endpoint) }.to change {
        namespace.endpoints.size
      }.by(1)
    end

    it 'sets the #namespace attribute of the endpoint to this namespace' do
      expect { namespace.add_endpoint(endpoint) }.to change {
        endpoint.namespace
      }.from(nil).to(namespace)
    end
  end

  describe '#get_endpoint' do
    let(:endpoint_name) { 'name' }
    let(:endpoint) { OpenStruct.new(name: endpoint_name) }

    context 'when the endpoint was not inserted' do
      it 'is nil' do
        expect(namespace.get_endpoint(endpoint_name)).to be_nil
      end
    end

    context 'when the endpoint is inside the namespace' do
      before do
        namespace.add_endpoint(endpoint)
      end

      it 'returns the endpoint' do
        expect(namespace.get_endpoint(endpoint_name)).to eq(endpoint)
      end
    end

    context 'when the endpoint is inside a child namespace' do
      before do
        child_namespace = namespace.add_anonymous_children_namespace
        child_namespace.add_endpoint(endpoint)
      end

      it 'returns the endpoint' do
        expect(namespace.get_endpoint(endpoint_name)).to eq(endpoint)
      end
    end
  end

  describe '#top_level_namespace?' do
    subject { used_namespace.top_level_namespace? }

    context 'with a child namespace' do
      let(:used_namespace) { namespace.add_anonymous_children_namespace }
      it { should eq(false) }
    end

    context 'with a normal namespace' do
      let(:used_namespace) { namespace }
      it { should eq(true) }
    end
  end

  describe '#full_base_path' do
    context 'for an anonymous namespace with parent' do
      let(:grand_parent) { Namespace.create('ns') }
      let(:parent) { grand_parent.add_anonymous_children_namespace }
      let(:namespace) { parent.add_anonymous_children_namespace }

      before do
        grand_parent.base_path = '/monkeys'
        parent.base_path = '/:id'
        namespace.base_path = '/notifications'
      end

      it 'is equal to the base_path plus the full_base_path of the parent' do
        expect(namespace.full_base_path).to eq('/monkeys/:id/notifications')
      end
    end

    context 'for a named namespace without parent' do
      let(:namespace) { Namespace.create('ns') }
      before { namespace.base_path = '/ns' }
      it 'is equal to the base_path' do
        expect(namespace.full_base_path).to eq('/ns')
      end
    end
  end

  describe '#name' do
    context 'for an anonymous namespace with parent' do
      let(:grand_parent) { Namespace.create('ns') }
      let(:parent) { Namespace.create('ns2').tap { |ns| ns.parent_namespace = grand_parent } }
      let(:namespace) { parent.add_anonymous_children_namespace }

      it 'is equal to the names joint by /' do
        expect(namespace.name).to eq('ns/ns2')
      end

      context 'if the namespace has a name too' do
        let(:namespace) { Namespace.create('ns3').tap { |ns| ns.parent_namespace = parent } }
        it 'the name is put at the end' do
          expect(namespace.name).to eq('ns/ns2/ns3') 
        end
      end
    end

    context 'for a named namespace without parent' do
      let(:namespace) { Namespace.create('ns') }
      it 'is equal to the name alone' do
        expect(namespace.name).to eq('ns')
      end
    end
  end
end
