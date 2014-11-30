require 'delegate'

module Restspec
  module Stores
    class EndpointStoreDelegator < SimpleDelegator
      def store(endpoint)
        self[endpoint.full_name] = endpoint
      end

      def get(endpoint_name)
        self[endpoint_name]
      end
    end

    EndpointStore = EndpointStoreDelegator.new(Hash.new)
  end

  EndpointStore = Stores::EndpointStore
end
