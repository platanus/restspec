require 'delegate'

module Restspec
  module Stores
    # Provides methods for the {EndpointStore} object.
    class EndpointStoreDelegator < SimpleDelegator
      # Stores an endpoint. It uses the {Restspec::Endpoints::Endpoint#full_name full_name}
      # method of the endpoint to use as the key for the endpoint itself.
      #
      # @param endpoint [Restspec::Endpoints::Endpoint] the endpoint to store.
      # @return [Restspec::Endpoints::Endpoint] the endpoint inserted.
      def store(endpoint)
        self[endpoint.full_name] = endpoint
      end

      # Get is just an alias for Hash#[]
      # @return [Restspec::Endpoints::Endpoint, nil] the endpoint found.
      def get(endpoint_name)
        self[endpoint_name]
      end

      # Get an endpoint by the schema and the name.
      #
      # @example
      #   # Let's assume in the store there are 3 endpoints
      #   # called :show, in different namespaces.
      #
      #   Restspec::EndpointStore.get_by_schema_and_name(:book, :show)
      #   # => this will only return the one whose schema is :book.
      #
      # @return [Restspec::Endpoints::Endpoint, nil] the endpoint found.
      def get_by_schema_and_name(schema_name, endpoint_name)
        values.find do |endpoint|
          endpoint.schema_name == schema_name && endpoint.name == endpoint_name
        end
      end
    end

    # The Endpoint Store is a Hash extended using {Stores::EndpointStoreDelegator}
    # This is where we store the endpoints to tests.
    #
    # It's important to note that, because this is a Hash, there can't be
    # two endpoint with the same full name. There can't be two endpoints
    # called `books/index` for example.
    EndpointStore = EndpointStoreDelegator.new(Hash.new)
  end

  # (see Stores::EndpointStore)
  EndpointStore = Stores::EndpointStore
end
