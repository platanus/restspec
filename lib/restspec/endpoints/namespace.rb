module Restspec
  module Endpoints
    class Namespace
      attr_accessor :schema_name, :base_path, :parent_namespace, :children_namespaces

      def initialize(name)
        self.name = name
        self.children_namespaces = []
      end

      def add_anonymous_children_namespace
        anonymous_namespace = Namespace.create_anonymous
        anonymous_namespace.parent_namespace = self
        children_namespaces << anonymous_namespace
        anonymous_namespace
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
        search_internal_endpoint(endpoint_name) || search_child_endpoint(endpoint_name)
      end

      def top_level_namespace?
        parent_namespace.nil?
      end

      def full_base_path
        if top_level_namespace?
          base_path
        else
          parent_namespace.full_base_path + base_path
        end
      end

      def actual_schema_name
        schema_name || parent_namespace.try(:actual_schema_name)
      end

      def name
        if top_level_namespace?
          @name
        else
          [parent_namespace.name, @name].reject(&:blank?).join('/')
        end
      end

      def anonymous?
        @name.blank?
      end

      private

      attr_writer :name

      def search_internal_endpoint(endpoint_name)
        endpoints.find do |endpoint|
          endpoint.name == endpoint_name
        end
      end

      def search_child_endpoint(endpoint_name)
        children_namespaces.each do |children_namespace|
          child_endpoint = children_namespace.get_endpoint(endpoint_name)
          return child_endpoint if child_endpoint.present?
        end

        return nil
      end

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
