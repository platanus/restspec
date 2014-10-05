require 'active_support/core_ext/object'

module Restspec
  module ApiHelpers
    def read_endpoint(endpoint_full_name = nil, body: {})
      if endpoint_full_name.present?
        endpoint = Namespace.get_by_full_name(endpoint_full_name)
        endpoint.execute(body: body).read_body
      else
        @endpoint.execute(body: body).read_body
      end
    end

    def schema_example(schema_name)
      Restspec.example_for(schema_name)      
    end
  end
end
