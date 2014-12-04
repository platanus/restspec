module Restspec
  module Endpoints
    module Network
      extend self

      def request(method, url, headers = {}, body = {})
        network_adapter.request(method, url, headers, (body || '').to_json)
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
        def request(method, url, headers, body)
          response = HTTParty.send(method, url, headers: headers, body: body)
          Response.new(response)
        end
      end
    end
  end
end
