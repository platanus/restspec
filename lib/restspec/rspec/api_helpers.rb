require 'active_support/core_ext/object'

module Restspec
  module RSpec
    module ApiHelpers
      def read_endpoint(endpoint_full_name = nil, options = {})
        call_endpoint(endpoint_full_name, options).read_body
      end

      def call_endpoint(endpoint_full_name, body: {},
                                            url_params: {},
                                            query_params: {},
                                            merge_example_params: true)
        endpoint = if endpoint_full_name.present?
          Restspec::Endpoints::Namespace.get_by_full_name(endpoint_full_name)
        else
          @endpoint
        end

        if merge_example_params
          query_params = (@query_params || {}).merge(query_params)
          url_params = (@url_params || {}).merge(url_params)
        end
        
        endpoint.execute(body: body, url_params: url_params, query_params: query_params)
      end

      def schema_example(schema_name)
        Restspec.example_for(schema_name)
      end

      def self.included(base)
        base.extend(self)
      end
    end
  end
end
