require 'spec_helper'

RSpec.describe 'Products endpoints', :type => :endpoint do
  endpoint 'products/index' do
    before(:all) do
      initial_products = read_endpoint
      if initial_products.size < 3
        3.times.map { read_endpoint('products/create', body: schema_example(:product)) }
      end
    end

    it { should have_status(:ok) }

    within_response do
      it { should have_at_least(3).items }

      it 'has all his objects according to the product schema' do
        subject.each do |product|
          expect(product).to be_like_schema(:product)
        end
      end
    end
  end

  endpoint 'products/create' do
    payload { schema_example(:product) }

    it { should have_status(:created) }
    it { should be_like_schema(:product) }
  end
end
