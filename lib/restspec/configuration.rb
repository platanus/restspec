require 'active_support/configurable'

module Restspec
  include ActiveSupport::Configurable

  class << self
    def configure
      config.request = OpenStruct.new(headers: {})
      config.request.headers['Content-Type'] = 'application/json'
      config.request.headers['Accept'] = 'application/json'

      config.custom = OpenStruct.new

      yield config

      populate_stores
    end

    def populate_stores
      load_schemas
      load_endpoint_definition
      load_requirement_definition
    end

    private

    def load_schemas
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
