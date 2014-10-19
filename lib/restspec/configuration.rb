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
    end

    def load_schema_definition
      definition = config.schema_definition
      Restspec.define_schemas do
        instance_eval(File.read(definition))
      end
    end

    def load_endpoint_definition
      definition = config.endpoints_definition
      Restspec.define_endpoints do
        instance_eval(File.read(definition))
      end
    end
  end
end
