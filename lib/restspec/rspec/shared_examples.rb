RSpec.shared_examples :successful_schema_fetch do
  it { should have_status(:ok) }
  it { should be_like_schema }
end

RSpec.shared_examples :a_not_found_test do
  test 'with a unexisting id' do
    url_params(id: 0)

    it { should have_status(:not_found) }
  end
end
