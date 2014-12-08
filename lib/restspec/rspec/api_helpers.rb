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
                                            merge_example_params: true,
                                            execution_method: :execute)
        endpoint = find_endpoint_in_test_context(endpoint_full_name)

        if merge_example_params
          query_params = (@query_params || {}).merge(query_params)
          url_params = (@url_params || {}).merge(url_params)
        end

        endpoint.send(execution_method, body: body, url_params: url_params, query_params: query_params)
      end

      def find_endpoint_in_test_context(endpoint_full_name)
        if endpoint_full_name.present?
          test_context = self.class

          test_context.metadata[:endpoints] ||= {}
          test_context.metadata[:endpoints][endpoint_full_name] ||= begin
            Restspec::EndpointStore.get(endpoint_full_name)
          end
        else
          @endpoint
        end
      end

      def read_endpoint_once(endpoint_full_name = nil, options = {})
        call_endpoint_once(endpoint_full_name, options).read_body
      end

      def call_endpoint_once(endpoint_full_name = nil, options = {})
        call_endpoint(endpoint_full_name, options.merge(:execution_method => :execute_once))
      end

      def execute_endpoint!
        execute_endpoint_lambda.call
        response
      end

      def schema_example(schema_name = nil)
        if schema_name.nil? && endpoint.present?
          schema_name = endpoint.schema_name
        end

        Restspec.example_for(schema_name)
      end

      def self.included(base)
        base.extend(self)
      end
    end
  end
end
