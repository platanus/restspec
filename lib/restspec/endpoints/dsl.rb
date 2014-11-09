require 'active_support/inflector'

module Restspec
  module Endpoints
    HTTP_METHODS = [:get, :post, :put, :patch, :delete, :head]

    class DSL
      def namespace(name, options = {}, &block)
        namespace = Namespace.get_or_create(name: name.to_s)
        namespace.set_options(options)
        namespace_dsl = NamespaceDSL.new(namespace)
        namespace_dsl.instance_eval(&block)
      end

      def resource(name, options = {}, &block)
        namespace name, options do
          self.resource_endpoint_base_path = "/#{name}"
          instance_eval(&block)

          if self.namespace.schema_name.blank?
            schema_name = name.to_s.singularize
            schema(schema_name.to_sym)
          end
        end
      end
    end

    class NamespaceDSL
      attr_accessor :namespace, :endpoint_base_path, :resource_endpoint_base_path, :common_endpoints_config_block

      def initialize(namespace)
        self.namespace = namespace
        self.endpoint_base_path = ''
        self.resource_endpoint_base_path = ''
      end

      def endpoint(name, &block)
        endpoint = Endpoint.new(name)
        endpoint_dsl = EndpointDSL.new(endpoint)
        endpoint_dsl.instance_eval(&block)
        endpoint_dsl.instance_eval(&common_endpoints_config_block)
        endpoint.path ||= ''
        endpoint.path = endpoint_base_path + endpoint.path
        namespace.add_endpoint(endpoint)
      end

      HTTP_METHODS.each do |http_method|
        define_method(http_method) do |name, path = '', &block|
          endpoint(name) do
            public_send(http_method, path)
            instance_eval(&block) if block.present?
          end
        end
      end

      def member(&block)
        original_base_path = self.endpoint_base_path
        self.endpoint_base_path += "#{resource_endpoint_base_path}/:id"
        instance_eval(&block)
        self.endpoint_base_path = original_base_path
      end

      def collection(&block)
        original_base_path = self.endpoint_base_path
        self.endpoint_base_path = resource_endpoint_base_path
        instance_eval(&block)
        self.endpoint_base_path = original_base_path
      end

      def schema(name)
        namespace.schema_name = name
      end

      def all(&endpoints_config)
        self.common_endpoints_config_block = endpoints_config
      end

      def common_endpoints_config_block
        @common_endpoints_config_block ||= (Proc.new {})
      end
    end

    class EndpointDSL < Struct.new(:endpoint)
      def method(method)
        endpoint.method = method
      end

      def path(path)
        endpoint.path = path
      end

      def schema(name)
        endpoint.schema_name = name
      end

      def headers
        endpoint.headers
      end

      HTTP_METHODS.each do |http_method|
        define_method(http_method) do |path|
          self.method http_method
          self.path path
        end
      end
    end
  end
end
