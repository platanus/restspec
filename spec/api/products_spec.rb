require 'spec_helper'

RSpec.describe :products, :type => :endpoint do
  endpoint :index, :get => '/products' do
    it { should have_status(:ok) }
  end

  endpoint :create, :post => '/products' do
    payload { schema_example(:product) }

    it { should have_status(:created) }
    it { should be_like_schema(:product) }
  end
end
