module Restspec
  module Endpoints
    module Network
      extend self

      # Make a request using a {Restspec::Endpoints::Request request} object
      # to some place. To actually send the information through the wire, this
      # method uses a network adapter, that defaults to an instance of {HTTPartyNetworkAdapter},
      # that uses the [httparty](https://github.com/jnunemaker/httparty) gem to make the request.
      #
      # The network adapter can be replaced setting the following option in the Restspec configuration:
      #
      # ```ruby
      # config.request.network_adapter = ->{ MyAwesomeNetworkAdapter.new }
      # ```
      # This new `MyAwesomeNetworkAdapter` class should respond to just one method called
      # `request` that returns a triad of values: A status code, the response headers and the
      # body of the response. For example:
      #
      # ```ruby
      # class MyAwesomeNetworkAdapter
      #   def request(request_object) # it just echoes the payload
      #     [200, {'Content-Type' => 'application/json'}, request_object.payload || {}]
      #   end
      # end
      # ```
      #
      # @param request [Restspec::Endpoints::Request] the request to make.
      # @return [Restspec::Endpoints::Response] the response from the wire.
      def request(request_object)
        code, headers, body = network_adapter.request(request_object)
        Response.new(code, headers, body)
      end

      private

      def network_adapter
        network_adapter_lambda.try(:call) || default_network_adapter
      end

      def network_adapter_lambda
        Restspec.config.request.try(:network_adapter)
      end

      def default_network_adapter
        HTTPartyNetworkAdapter.new
      end

      # It uses [httparty](https://github.com/jnunemaker/httparty) to make a request.
      class HTTPartyNetworkAdapter
        # @param request_object [Restspec::Endpoints::Request] the request to make.
        # @return Array of three values representing the status code, the response's headers and the response's body. The first one is a number and the last two are hashes.
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
