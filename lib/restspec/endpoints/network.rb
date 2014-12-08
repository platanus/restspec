module Restspec
  module Endpoints
    module Network
      extend self

      def request(request_object)
        code, headers, body = network_adapter.request(request_object)
        Response.new(code, headers, body)
      end

      private

      def network_adapter
        network_adapter_lambda.try(:call) || default_network_adapter
      end

      def network_adapter_lambda
        Restspec.config.request.network_adapter
      end

      def default_network_adapter
        HTTPartyNetworkAdapter.new
      end

      class HTTPartyNetworkAdapter
        def request(request_object)
          response = HTTParty.send(
            request_object.method,
            request_object.url,
            headers: request_object.headers,
            body: request_object.raw_payload
          )

          [response.code, response.headers, response.body]
        end
      end
    end
  end
end
