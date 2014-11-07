RSpec.shared_examples :successful_schema_fetch do
  it { should have_status(:ok) }
  it { should be_like_schema }
end
