require_relative './matchers/api_matchers'

module Restspec
  module RSpec
    module ApiMacros
      def endpoint(name, &block)
        endpoint = Restspec::Endpoints::Namespace.get_by_full_name(name)

        # Instance variables in the example context
        #   - @namespace
        #   - @endpoint
        #   - @response
        describe "#{endpoint.name} : [#{endpoint.method.to_s.upcase} #{endpoint.path}]" do
          before(:all) do
            @namespace = endpoint.namespace
            @endpoint = endpoint
          end

          subject do
            @response = @endpoint.execute_once(body: @payload, url_params: @url_params, query_params: @query_params)
          end

          instance_eval(&block)
        end
      end

      def payload
        before(:all) { @payload = Restspec::Values::SuperHash.new(yield) }
        let(:payload) { @payload }
      end

      def url_params
        before(:all) { @url_params = Restspec::Values::SuperHash.new(yield) }
        let(:url_params) { @url_params }
      end

      def query_params
        before(:all) { @query_params = Restspec::Values::SuperHash.new(yield) }
        let(:query_params) { @query_params }
      end

      def schema_example(schema_name)
        Restspec.example_for(schema_name)
      end

      def within_response(&block)
        context 'within response' do
          subject do
            @response = @endpoint.execute_once(body: payload)
            @response.body
          end

          instance_eval(&block)
        end
      end
    end
  end
end
