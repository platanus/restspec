require 'spec_helper'

include Restspec::Schema

describe Finder do
  let(:finder) { Finder.new }
  let(:schema_name) { 'schema' }

  subject { finder.find(schema_name) }

  context 'without schemas' do
    it { should eq(nil) }
  end

  context 'with schemas' do
    let(:schema) { double(name: schema_name) }

    before do
      Restspec::SchemaStore.store(schema)
    end

    it { should eq(schema) }
  end
end
