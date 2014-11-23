require_relative './matchers/api_matchers'

module Restspec
  module RSpec
    module ApiMacros
      def endpoint(name, implicit_test: false, &block)
        endpoint = Restspec::Endpoints::Namespace.create_by_full_name(name)

        self.metadata[:current_endpoint] = endpoint

        describe "[#{endpoint.method.to_s.upcase} #{endpoint.name}]" do
          implicit_test ? test(&block) : instance_eval(&block)
        end
      end

      def test(message = 'the happy path', &test_body)
        context(message) do
          let(:endpoint) { self.class.metadata[:current_endpoint].clone }

          let(:response) do
            @response = endpoint.execute_once(
              body: payload.merge(@payload || {}),
              url_params: url_params.merge(@url_params || {}),
              query_params: query_params.merge(@query_params || {})
            )
          end

          let(:body) { response.body }

          subject { response }

          let(:payload) do
            defined?(example_payload) ? example_payload : {}
          end

          let(:url_params) do
            defined?(example_url_params) ? example_url_params : {}
          end

          let(:query_params) do
            defined?(example_query_params) ? example_query_params : {}
          end

          instance_eval(&test_body)
        end
      end

      def payload(params = nil, &payload_block)
        let(:example_payload) do
          Restspec::Values::SuperHash.new(params || instance_eval(&payload_block))
        end
      end

      def url_params(params = nil, &params_block)
        let(:example_url_params) do
          Restspec::Values::SuperHash.new(params || instance_eval(&params_block))
        end
      end

      def query_params(params = nil, &params_block)
        let(:example_query_params) do
          Restspec::Values::SuperHash.new(params || instance_eval(&params_block))
        end
      end

      def schema_example(schema_name = nil, extensions = {})
        if schema_name.nil? && metadata[:current_endpoint]
          schema_name = metadata[:current_endpoint].schema_name
        end
        
        Restspec.example_for(schema_name, extensions)
      end

      def assert_requirement!(name)
        requirement = Restspec::Requirements::Requirement.find_by_name(name)
        requirement.assert!
      end

      def within_response(&block)
        context 'within response' do
          subject { response.body }
          instance_eval(&block)
        end
      end
    end
  end
end
