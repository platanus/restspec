Restspec.configure do |config|
  config.base_url = 'http://localhost:3000'
  config.schema_definition = "#{File.dirname __FILE__}/schemas.rb"
  config.endpoints_definition = "#{File.dirname __FILE__}/endpoints.rb"
  config.requirements_definition = "#{File.dirname __FILE__}/requirements.rb"
end
