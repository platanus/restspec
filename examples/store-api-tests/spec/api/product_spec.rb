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

  endpoint 'products/update', focus: true do
    payload do
      { name: schema_example(:product)[:name] }
    end

    test do
      before do
        @original_product = read_endpoint_once('products/show', {
          url_params: { id: endpoint.url_params.id }
        })
      end

      it { should have_status(:ok) }
      it { should be_like_schema }

      it 'updates the name' do
        expect(body.name).to_not eq(@original_product.name)
        expect(body.name).to eq(request.payload.name)
      end
    end
  end

  endpoint 'products/destroy' do
    test do
      it { should have_status(:no_content) }

      it 'actually destroyed the product' do
        response = call_endpoint('products/show', { url_params: { id: endpoint.url_params.id } })
        expect(response).to have_status(:not_found)
      end
    end
  end
end
