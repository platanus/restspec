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

      def get_by_schema_and_name(schema_name, endpoint_name)
        values.find do |endpoint|
          endpoint.schema_name == schema_name && endpoint.name == endpoint_name
        end
      end
    end

    EndpointStore = EndpointStoreDelegator.new(Hash.new)
  end

  EndpointStore = Stores::EndpointStore
end
