module Restspec
  class Namespace < Struct.new(:name)
    def add_endpoint(endpoint_name, method, path)
      Restspec::Endpoint.new(endpoint_name, method, path, self).tap do |endpoint|
        endpoints << endpoint
      end
    end

    def endpoints
      @endpoints ||= []
    end
  end

  class << Namespace
    attr_accessor :namespaces

    def get_or_create(name: nil)
      get(name) || create(name)
    end

    def get(name)
      namespaces.find do |ns|
        ns.name == name
      end
    end

    def get_by_full_name(full_name)
      endpoints.find do |endpoint|
        endpoint.full_name == full_name
      end
    end

    def create(name)
      new(name).tap do |ns|
        namespaces << ns
      end
    end

    def namespaces
      @namespaces ||= []
    end

    private

    def endpoints
      namespaces.map(&:endpoints).flatten
    end
  end
end
