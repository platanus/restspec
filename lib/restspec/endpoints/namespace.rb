module Restspec
  module Endpoints
    class Namespace
      attr_accessor :schema_name, :base_path, :namespace

      def initialize(name)
        self.name = name
      end

      def set_options(options)
        self.base_path = options[:base_path] if options[:base_path]
      end

      def endpoints
        @endpoints ||= []
      end

      def add_endpoint(endpoint)
        endpoint.namespace = self
        endpoints << endpoint
        endpoint
      end

      def get_endpoint(endpoint_name)
        endpoints.find do |endpoint|
          endpoint.name == endpoint_name
        end
      end

      def top_level_namespace?
        namespace.nil?
      end

      def full_base_path
        if top_level_namespace?
          base_path
        else
          namespace.full_base_path + base_path
        end
      end

      def actual_schema_name
        schema_name || namespace.try(:schema_name)
      end

      def name
        if top_level_namespace?
          @name
        else
          [namespace.name, @name].reject(&:blank?).join('/')
        end
      end

      def anonymous?
        @name.blank?
      end

      private

      attr_writer :name

      def base_path
        @base_path ||= ''
      end
    end

    class << Namespace
      def get_or_create(name: nil)
        get(name) || create(name)
      end

      def get(name)
        namespaces[name]
      end

      def create_anonymous
        create('')
      end

      def get_by_schema_name(schema_name)
        namespaces.find do |_, namespace|
          namespace.schema_name == schema_name
        end.last
      end

      def create(name)
        new(name).tap do |namespace|
          namespaces[name] = namespace
        end
      end

      def namespaces
        Restspec::NamespaceStore
      end
    end
  end
end
