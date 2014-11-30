module Restspec::Endpoints
  class Finder
    def find(full_name)
      endpoint_store[full_name]
    end

    private

    def endpoint_store
      Restspec::EndpointStore
    end
  end
end
