require 'spec_helper'

RSpec.describe :products, :type => :api do
  endpoint 'products/create' do
    test do
      payload { schema_example(:product) }

      it { should have_status(:created) }
    end
  end

  endpoint 'products/show' do
    test do
      it { should have_status(:ok) }
      it { should be_like_schema }
    end
  end

  endpoint 'products/index' do
    test do
      it { should have_status(:ok) }
      it { should be_like_schema_array }
    end
  end

  endpoint 'products/update', resource: 'products/show' do
    payload { schema_example(:product) }

    test do
      it 'updates the name' do
        expect(final_resource.name).to_not eq(initial_resource.name)
        expect(final_resource.name).to eq(request.payload.name)
      end
    end
  end

  endpoint 'products/destroy', resource: 'products/show' do
    test do
      it { should have_status(:no_content) }

      it 'actually destroyed the product' do
        resource_after_destruction = resource_endpoint.execute
        expect(resource_after_destruction).to have_status(:not_found)
      end
    end
  end
end
