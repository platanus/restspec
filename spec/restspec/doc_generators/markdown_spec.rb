require 'spec_helper'
require 'restspec'
require 'restspec/doc_generators/markdown'

def clear_stores
  Restspec::NamespaceStore.clear
  Restspec::EndpointStore.clear
  Restspec::SchemaStore.clear
end

def populate_endpoints
  Restspec::Endpoints::DSL.new.instance_eval do
    resource :products do
      schema :product

      collection do
        post :create
        get :index do
          schema :product, without: [:category]
        end
      end

      member do
        url_param(:id) { schema_id(:product) }

        get :show
        put :update
        delete :destroy
      end
    end

    resource :categories do
      schema :category

      collection do
        post :create
        get :index
      end

      member do
        url_param(:id) { schema_id(:category) }

        get :show
        put :update
        delete :destroy

        get :products, '/products' do
          schema :product
        end
      end
    end
  end
end

def populate_schemas
  Restspec::Schema::DSL.new.instance_eval do
    schema :product do
      attribute :name, string
      attribute :code, string
      attribute :price, decimal | decimal_string
      attribute :category_id, schema_id(:category)
      attribute :category, embedded_schema(:category), :for => [:checks]
    end

    schema :category do
      attribute :name, string
    end
  end
end

describe Restspec::DocGenerators::Markdown do
  before do
    clear_stores
    populate_schemas
    populate_endpoints
  end

  let(:generator) { Restspec::DocGenerators::Markdown.new }

  describe '#generate' do
    it 'only happens for exploration' do
      # require 'pry'; binding.pry
      puts "\n" * 3
      puts generator.generate
      puts "\n" * 3
    end
  end
end
