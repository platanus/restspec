Restspec.configure do |config|
  config.base_url = '<%= options[:api_prefix] %>'
  config.schema_definition = "#{File.dirname __FILE__}/api/restspec/api_schemas.rb"
  config.endpoints_definition = "#{File.dirname __FILE__}/api/restspec/api_endpoints.rb"
  config.requirements_definition = "#{File.dirname __FILE__}/api/restspec/api_requirements.rb"
end
