require 'spec_helper'

RSpec.describe :categories, :type => :endpoint do
  endpoint :index, :get => '/categories' do
    before(:all) do
      initial_categories = read_endpoint
      if initial_categories.size < 3
        3.times.map { read_endpoint('categories/create', body: { category: schema_example(:category) }) }
      end
    end

    it { should have_status(:ok) }
    it { should have_header('content-type') }
    it { should have_header('content-type').equals('application/json; charset=utf-8') }
    it { should have_header('content-type').that_contains('application/json') }
    it { should have_header('content-type').that_contains(/json/) }

    its(:body) { should have_at_least(3).items }
    # it { should be_like_schema(:category) }
  end

  endpoint :create, :post => '/categories' do
    payload do
      { category: schema_example(:category) }
      # { category: { name: 'Super Category' } }
    end

    it { should have_status(:created) }

    its('body.name') { should eq(payload.category[:name]) }
    # it { should be_like_schema(:category) }
  end
end
