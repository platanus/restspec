require_relative './matchers/api_matchers'

module Restspec
  module RSpec
    module ApiMacros
      def endpoint(name, context: nil, &block)
        endpoint = Restspec::Endpoints::Namespace.create_by_full_name(name)
        context_message = context

        self.metadata[:current_endpoint] = endpoint

        # Instance variables in the example context
        #   - @namespace
        #   - @endpoint
        #   - @response
        test_body = proc do
          before(:context) do
            @namespace = endpoint.namespace
            @endpoint = endpoint
          end

          subject do
            @response = @endpoint.execute_once(
              body: @payload,
              url_params: @url_params,
              query_params: @query_params
            )
          end

          let(:response) { subject }
          let(:body) { response.body }

          instance_eval(&block)
        end

        describe "#{endpoint.name} : [#{endpoint.method.to_s.upcase} #{endpoint.path}]" do
          if context_message
            context context_message do
              instance_eval(&test_body)
            end
          else
            instance_eval(&test_body)
          end
        end
      end

      def payload
        before(:context) { @payload = Restspec::Values::SuperHash.new(yield) }
        let(:payload) { @payload }
      end

      def url_params(params = nil)
        before(:context) { @url_params = Restspec::Values::SuperHash.new(params || yield) }
        let(:url_params) { @url_params }
      end

      def query_params(params = nil)
        before(:context) { @query_params = Restspec::Values::SuperHash.new(params || yield) }
        let(:query_params) { @query_params }
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
          subject do
            @response = @endpoint.execute_once(
              body: @payload,
              url_params: @url_params,
              query_params: @query_params
            )
            @response.body
          end

          instance_eval(&block)
        end
      end
    end
  end
end
