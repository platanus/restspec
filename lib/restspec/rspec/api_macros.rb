module Restspec
  module RSpec
    module ApiMacros
      def endpoint(endpoint_name, options, &block)
        # Instance variables used
        #   - @namespace
        #   - @endpoint
        #   - @response

        require_relative './matchers/api_matchers'

        method, path = options.first

        namespace_name = described_class
        namespace = Restspec::Namespace.get_or_create(name: namespace_name.to_s)
        endpoint = namespace.add_endpoint(endpoint_name, method, path)

        describe "#{endpoint_name} : [#{method.to_s.upcase} #{path}]" do
          before(:all) do
            @namespace = namespace
            @endpoint = endpoint
          end

          let(:payload) { Hash.new }

          subject do
            @response = endpoint.execute_once(body: payload)
          end

          instance_eval(&block)
        end
      end

      def payload
        before(:all) { @payload = SuperHash.new(yield) }
        let(:payload) { @payload }
      end

      def schema_example(schema_name)
        Restspec.example_for(schema_name)
      end
    end
  end
end
