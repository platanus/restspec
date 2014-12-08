require 'spec_helper'

RSpec.describe :categories, :type => :api do
  endpoint 'categories/create' do
    test do
      payload { schema_example(:category) }

      it { should have_status(:created) }
    end
  end

  endpoint 'categories/products', focus: true do
    test do
      # it { should have_status(:ok) }
      # it { should be_like_schema_array }
    end

    test 'with an unexisting category' do
      url_params id: '0'
      it { should have_status(:not_found) }
    end
  end
end
