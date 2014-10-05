require 'spec_helper'

RSpec.describe :categories, :type => :endpoint do
  endpoint :index, :get => '/categories' do
    before(:all) do
      initial_categories = read_endpoint
      if initial_categories.size < 3
        3.times.map { read_endpoint('categories/create', body: schema_example(:category)) }
      end
    end

    it { should have_status(:ok) }
    it { should have_header('content-type') }
    it { should have_header('content-type').equals('application/json; charset=utf-8') }
    it { should have_header('content-type').that_contains('application/json') }
    it { should have_header('content-type').that_contains(/json/) }
    it { should be_like_schema(:category) }

    its(:body) { should have_at_least(3).items }
  end

  endpoint :create, :post => '/categories' do
    payload { schema_example(:category) }

    it { should have_status(:created) }
    it { should be_like_schema(:category) }

    its('body.name') { should eq(payload.name) }
  end
end
