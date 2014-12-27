require 'active_support/inflector'

module Restspec
  module Endpoints
    HTTP_METHODS = [:get, :post, :put, :patch, :delete, :head]

    # The Endpoints DSL is what should be used inside the `endpoints.rb` file.
    # This class is related to the top-level namespace of the DSL.
    class DSL
      # Generates a new namespace that is just an entity that
      # groups a couple of endpoints for whatever reason.
      #
      # @example with only a name
      #   namespace :books do
      #   end
      #
      # @example with a `base_path`
      #   namespace :books, base_path: '/publications' do
      #   end
      #
      # @param name [String] the name of the namespace.
      # @param base_path [String, nil] the base_path property of the namespace.
      # @param block [:call] a block to yield to a newly created {NamespaceDSL}.
      def namespace(name, base_path: nil, &block)
        namespace = Namespace.create(name.to_s)
        namespace.base_path = base_path
        namespace_dsl = NamespaceDSL.new(namespace)
        namespace_dsl.instance_eval(&block)
      end

      # This is actually a kind of namespace factory, that creates
      # a namespace that have the next conventions:
      #   - The name is a pluralization of another name. (products, books, etc)
      #   - The base_path is, when not defined, the name of the namespace prepended with a "/"
      #   - Attaches a schema with the name of the namespace singularized to the namespace.
      #     (product, book, etc)
      #
      # In this way, it can express REST resources that groups a couple of endpoints related
      # to them.
      #
      # @example
      #   resource :books do
      #     namespace.schema_name # book
      #     namespace.base_path # /books
      #   end
      #
      # @param (see #namespace)
      #
      def resource(name, base_path: nil, &block)
        namespace name, base_path: (base_path || "/#{name}") do
          if self.namespace.schema_name.blank?
            schema_name = name.to_s.singularize
            schema(schema_name.to_sym)
          end

          instance_eval(&block)
        end
      end
    end

    # The Namespace DSL is what should be used inside a namespace or resource block.
    # Its major responsability is to add endpoints to the dsl.
    class NamespaceDSL
      attr_accessor :namespace

      def initialize(namespace)
        self.namespace = namespace
      end

      # Defines a new endpoint with a name and a block
      # that has a context equals to a {EndpointDSL} instance
      # and saves the endpoint into the namespace.
      #
      # @example
      #   namespace :books do
      #     endpoint :get do
      #     end
      #   end
      #
      # @param name [Symbol] the endpoint name.
      # @param block [block] the block to call within an {EndpointDSL} instance.
      def endpoint(name, &block)
        endpoint = Endpoint.new(name)
        endpoint_dsl = EndpointDSL.new(endpoint)
        namespace.add_endpoint(endpoint)

        endpoint_dsl.instance_eval(&block)
        endpoint_dsl.instance_eval(&common_endpoints_config_block)

        Restspec::EndpointStore.store(endpoint)
      end

      # @!macro http_method_endpoint
      #   Defines an endpoint with a **$0** http method.
      #
      #   @example
      #     namespace :books do
      #       $0 :endpoint_name, '/path' # this endpoint will have the $0 http method attached
      #     end
      #
      #   @param name [String] the name of the endpoint.
      #   @param path [String] the optional path of the endpoint.
      #   @param block [block] the block to call with the {EndpointDSL} instance.

      # @macro http_method_endpoint
      def get(name, path = '', &block)
        setup_endpoint_from_http_method(:get, name, path, &block)
      end

      # @macro http_method_endpoint
      def post(name, path = '', &block)
        setup_endpoint_from_http_method(:post, name, path, &block)
      end

      # @macro http_method_endpoint
      def put(name, path = '', &block)
        setup_endpoint_from_http_method(:put, name, path, &block)
      end

      # @macro http_method_endpoint
      def patch(name, path = '', &block)
        setup_endpoint_from_http_method(:patch, name, path, &block)
      end

      # @macro http_method_endpoint
      def delete(name, path = '', &block)
        setup_endpoint_from_http_method(:delete, name, path, &block)
      end

      # @macro http_method_endpoint
      def head(name, path = '', &block)
        setup_endpoint_from_http_method(:head, name, path, &block)
      end

      # This defines an anonymous namespace with a base_path equals
      # to '/:id' that will affect all his internals endpoints
      # with the base_path of the parent namespace. Esentially:
      #
      # @example
      #   resource :books do
      #     member do
      #       get :show # /books/:id
      #       patch :update # /books/:id
      #       get :chapters, '/chapters' # /books/:id/chapters
      #     end
      #   end
      #
      # @param base_path [String, nil] override of the base_pat
      # @param identifier_name [String, :id] override of the key :id
      # @param block [block] block that will be called with a {NamespaceDSL instance},
      #   typically for create endpoints inside.
      def member(base_path: nil, identifier_name: 'id', &block)
        member_namespace = namespace.add_anonymous_children_namespace
        member_namespace.base_path = base_path || "/:#{identifier_name}"
        NamespaceDSL.new(member_namespace).instance_eval(&block)
      end

      # This defines an anonymous namespace with a base_path equals
      # to the empty string that will affect all his internals endpoints
      # with the base_path of the parent namespace. This should be used
      # to group collection related endpoints.
      #
      # @example
      #   resource :books do
      #     collection do
      #       get :index # /books
      #       post :create # /books
      #     end
      #   end
      #
      # @param base_path [String, nil] override of the base_pat
      # @param block [block] block that will be called with a {NamespaceDSL instance},
      #   typically for create endpoints inside.
      def collection(base_path: nil, &block)
        collection_namespace = namespace.add_anonymous_children_namespace
        collection_namespace.base_path = base_path
        NamespaceDSL.new(collection_namespace).instance_eval(&block)
      end

      # It attaches a schema to the namespace. This schema name will be
      # used by the endpoints inside the namespace too.
      #
      # @example
      #   namespace :products do
      #     schema :product
      #   end
      #
      # @param name [Symbol] the schema name.
      # @param schema_extensions [Hash] extensions to be passed with the schema. See the {Restspec::Schema::Schema#extend_with} method for options.
      def schema(name, schema_extensions = {})
        namespace.schema_name = name
        namespace.schema_extensions = schema_extensions
      end

      # Defines a block that will be executed in every endpoint inside this namespace.
      # It should only be one for namespace.
      #
      # @example
      #   resource :products, base_path: '/:country_id/products' do
      #     member do
      #       all do
      #         url_params(:country_id) { 'us' }
      #       end
      #
      #       get :show # /us/products/:id
      #       put :update # /us/products/us/:id
      #     end
      #   end
      #
      # @param endpoints_config [block] block that will be called in the context of
      #   an {EndpointDSL} instance.
      def all(&endpoints_config)
        self.common_endpoints_config_block = endpoints_config
      end

      # It calls {#all} with the {EndpointDSL#url_param} method.
      # Please refer to the {EndpointDSL#url_param} method.
      def url_param(param, &value_or_example_block)
        all do
          url_param(param, &value_or_example_block)
        end
      end

      private

      attr_accessor :common_endpoints_config_block

      def setup_endpoint_from_http_method(http_method, endpoint_name, path, &block)
        endpoint(endpoint_name) do
          self.method http_method
          self.path path
          instance_eval(&block) if block.present?
        end
      end

      def common_endpoints_config_block
        @common_endpoints_config_block ||= (Proc.new {})
      end
    end

    # The Endpoint DSL is what should be used inside an endpoint block.
    # Its major responsability is to define endpoint behavior.
    class EndpointDSL < Struct.new(:endpoint)
      # Defines what the HTTP method will be.
      #
      # @example
      #   endpoint :show do
      #     method :get
      #   end
      #
      # @param method [Symbol] the http method name
      def method(method)
        endpoint.method = method
      end

      # Defines what the path will be. It will be append
      # to the namespace's `base_path` and to the Restspec
      # config's `base_url`.
      #
      # @example
      #   endpoint :monkeys do
      #     path '/monkeys'
      #   end
      #
      # @param path [String] the path of the endpoint
      def path(path)
        endpoint.path = path
      end

      # Defines what the schema will be.
      #
      # @example
      #   endpoint :monkeys do
      #     schema :monkey
      #   end
      #
      #
      #
      # @param name [Symbol] the schema's name.
      # @param schema_extensions (see NamespaceDSL#schema)
      def schema(name, schema_extensions = {})
        endpoint.schema_name = name
        endpoint.schema_extensions = schema_extensions
      end

      # A mutable hash containing the headers for the endpoint
      #
      # @example
      #   endpoint :monkeys do
      #     headers['Content-Type'] = 'application/json'
      #   end
      def headers
        endpoint.headers
      end

      # This set url parameters for the endpoint. It receives a key and a block
      # returning the value. If the value is a type, an example will be generated.
      #
      # @example with just a value:
      #   endpoint :monkeys, path: '/:id' do
      #     url_param(:id) { '1' }
      #   end # /1
      #
      # @example with a type:
      #   endpoint :monkeys, path: '/:id' do
      #     url_param(:id) { string } # a random string
      #   end # /{the random string}
      #
      # @param param [Symbol] the parameter name.
      # @param value_or_type_block [block] the block returning the value.
      def url_param(param, &value_or_type_block)
        endpoint.add_url_param_block(param) do
          ExampleOrValue.new(endpoint, param, value_or_type_block).value
        end
      end

      # A special class to get a type example or a simple
      # value from a block.
      #
      # If the block returns a type, the result should
      # be one example of that type.
      class ExampleOrValue
        def initialize(endpoint, attribute_name, callable)
          self.attribute_name = attribute_name
          self.endpoint = endpoint
          self.callable = callable
        end

        def value
          if example?
            raw_value.example_for(get_attribute)
          else
            raw_value
          end
        end

        private

        attr_accessor :attribute_name, :callable, :endpoint

        def example?
          raw_value.is_a?(Restspec::Schema::Types::BasicType)
        end

        def get_attribute
          if endpoint.schema && endpoint.schema.attributes[attribute_name]
            endpoint.schema.attributes[attribute_name]
          else
            Restspec::Schema::Attribute.new(attribute_name, context.integer)
          end
        end

        def raw_value
          @raw_value ||= context.instance_eval(&callable)
        end

        def context
          @context ||= Object.new.tap do |context|
            context.extend(Restspec::Schema::Types::TypeMethods)
          end
        end
      end
    end
  end
end
