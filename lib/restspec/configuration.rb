require 'active_support/configurable'

module Restspec
  include ActiveSupport::Configurable

  class << self
    # Configure Restspec and loads the information of the API defined in the DSL definitions if the DSL definitions are defined.
    #
    # The following options are available:
    #
    #   - **base_url**: The base url of the API. It is a full url, not only a domain, so it can include more than just the api url but a version path like: `http://localhost:3000/api/v1`.
    #   - **schema_definition**: The file location where the file describing the schemas is located.
    #   - **endpoints_definition**: The file location where the file describing the endpoints is located.
    #   - **requirements_definition**: The file location where the file describing the requirements is located.
    #   - **request**: An object that configures the default request. It has a header hash inside to set default headers for every request.
    #   - **custom**: An object to hold custom configuration. It can be accessed anywhere using `Restspec.custom`.
    #
    # @yield [config] A block describing the Restspec configuration
    #
    # @example Defines some configuration options:
    #   Restspec.configure do |config|
    #     config.base_url = 'http://localhost:3000/api/v1'
    #
    #     config.schema_definition = "#{File.dirname __FILE__}/schemas.rb"
    #     config.endpoints_definition = "#{File.dirname __FILE__}/endpoints.rb"
    #     config.requirements_definition = "#{File.dirname __FILE__}/requirements.rb"
    #
    #     config.custom.api_key = ENV['API_KEY']
    #     config.request.headers['AUTHORIZATION'] = "Token token=\"#{config.custom.api_key}\""
    #   end
    def configure
      config.request = OpenStruct.new(headers: {})
      config.request.headers['Content-Type'] = 'application/json'
      config.request.headers['Accept'] = 'application/json'

      config.custom = OpenStruct.new

      yield config

      populate_stores
    end

    private

    def populate_stores
      load_schemas_definition
      load_endpoint_definition
      load_requirement_definition
    end

    def load_schemas_definition
      eval_file Schema::DSL.new, config.schema_definition
    end

    def load_endpoint_definition
      eval_file Endpoints::DSL.new, config.endpoints_definition
    end

    def load_requirement_definition
      eval_file Requirements::DSL.new, config.requirements_definition
    end

    def eval_file(object, file_name)
      object.instance_eval(File.read(file_name)) if file_name.present?
    end
  end
end
