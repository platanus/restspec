module Restspec
  module Endpoints
    class DSL
      def namespace(name, &block)
        namespace = Namespace.get_or_create(name: name.to_s)
        namespace_dsl = NamespaceDSL.new(namespace)
        namespace_dsl.instance_eval(&block)
      end
    end

    class NamespaceDSL < Struct.new(:namespace)
      def endpoint(name, &block)
        endpoint = Endpoint.new(name)
        endpoint_dsl = EndpointDSL.new(endpoint)
        endpoint_dsl.instance_eval(&block)
        namespace.add_endpoint(endpoint)
      end
    end

    class EndpointDSL < Struct.new(:endpoint)
      def method(method)
        endpoint.method = method
      end

      def path(path)
        endpoint.path = path
      end
    end
  end
end
