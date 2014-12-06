require 'spec_helper'

RSpec.describe :categories, :type => :api do
  endpoint 'categories/create' do
    endpoint 'categories/create' do
      test do
        payload { schema_example(:category) }

        it { should have_status(:created) }
      end
    end
  end
end
