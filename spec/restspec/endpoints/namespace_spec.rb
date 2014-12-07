require 'spec_helper'

include Restspec::Endpoints

describe Namespace do
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
end
