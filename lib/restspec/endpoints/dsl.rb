require 'active_support/inflector'

module Restspec
  module Endpoints
    HTTP_METHODS = [:get, :post, :put, :patch, :delete, :head]

    class DSL
      def namespace(name, base_path: nil, &block)
        namespace = Namespace.create(name.to_s)
        namespace.base_path = base_path
        namespace_dsl = NamespaceDSL.new(namespace)
        namespace_dsl.instance_eval(&block)
      end

      def resource(name, options = {}, &block)
        namespace name, base_path: (options[:base_path] || "/#{name}") do
          if self.namespace.schema_name.blank?
            schema_name = name.to_s.singularize
            schema(schema_name.to_sym)
          end

          instance_eval(&block)
        end
      end
    end

    class NamespaceDSL
      attr_accessor :namespace, :endpoint_base_path, :resource_endpoint_base_path, :common_endpoints_config_block

      def initialize(namespace)
        self.namespace = namespace
        self.resource_endpoint_base_path = ''
      end

      def endpoint(name, &block)
        endpoint = Endpoint.new(name)
        endpoint_dsl = EndpointDSL.new(endpoint)
        namespace.add_endpoint(endpoint)

        endpoint_dsl.instance_eval(&block)
        endpoint_dsl.instance_eval(&common_endpoints_config_block)

        Restspec::EndpointStore.store(endpoint)
      end

      HTTP_METHODS.each do |http_method|
        define_method(http_method) do |name, path = '', &block|
          endpoint(name) do
            public_send(http_method, path)
            instance_eval(&block) if block.present?
          end
        end
      end

      def member(base_path: nil, identifier_name: 'id', &block)
        member_namespace = namespace.add_anonymous_children_namespace
        member_namespace.base_path = base_path || "/:#{identifier_name}"
        NamespaceDSL.new(member_namespace).instance_eval(&block)
      end

      def collection(base_path: nil, &block)
        collection_namespace = namespace.add_anonymous_children_namespace
        collection_namespace.base_path = base_path
        NamespaceDSL.new(collection_namespace).instance_eval(&block)
      end

      def schema(name, schema_extensions = {})
        namespace.schema_name = name
        namespace.schema_extensions = schema_extensions
      end

      def all(&endpoints_config)
        self.common_endpoints_config_block = endpoints_config
      end

      def url_param(param, &value_or_example_block)
        all do
          url_param(param, &value_or_example_block)
        end
      end

      private

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

      def schema(name, schema_extensions = {})
        endpoint.schema_name = name
        endpoint.schema_extensions = schema_extensions
      end

      def headers
        endpoint.headers
      end

      def url_param(param, &value_or_type_block)
        endpoint.add_url_param_block(param) do
          value_or_type_context = ValueOrTypeContext.new
          value_or_type = value_or_type_context.instance_eval(&value_or_type_block)

          if value_or_type.is_a?(Restspec::Schema::Types::BasicType)
            attribute = if endpoint.schema && endpoint.schema.attributes[param]
              endpoint.schema.attributes[param]
            else
              Restspec::Schema::Attribute.new(param, value_or_type_context.integer)
            end

            value_or_type.example_for(attribute)
          else
            value_or_type
          end
        end
      end

      HTTP_METHODS.each do |http_method|
        define_method(http_method) do |path|
          self.method http_method
          self.path path
        end
      end
    end

    class ValueOrTypeContext
      Restspec::Schema::Types::ALL.each do |type_name, type_class|
        define_method(type_name) do |options = {}|
          type_class.new(options)
        end
      end
    end
  end
end
