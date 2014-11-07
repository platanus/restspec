require 'active_support/configurable'

module Restspec
  include ActiveSupport::Configurable

  class << self
    def configure
      # TODO: This is json specific, try to refactor if needed
      config.request = OpenStruct.new(headers: {})
      config.request.headers['Content-Type'] = 'application/json'
      config.request.headers['Accept'] = 'application/json'

      yield config

      load_schema_definition if config.schema_definition.present?
      load_endpoint_definition if config.endpoints_definition.present?
      load_requirement_definition if config.requirements_definition.present?
    end

    private

    def load_schema_definition
      load_definition config.schema_definition, :define_schemas
    end

    def load_endpoint_definition
      load_definition config.endpoints_definition, :define_endpoints
    end

    def load_requirement_definition
      load_definition config.requirements_definition, :define_requirements
    end

    def load_definition(definition_file, definition_method)
      Restspec.public_send definition_method do
        instance_eval(File.read(definition_file))
      end
    end
  end
end
