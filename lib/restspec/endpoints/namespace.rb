module Restspec
  module Endpoints
    class Namespace
      include HasSchemas

      attr_accessor :base_path, :parent_namespace, :children_namespaces
      attr_reader :endpoints

      def self.create(name)
        namespace = new(name)
        Stores::NamespaceStore.store(namespace)
        namespace
      end

      def initialize(name = '')
        self.name = name
        self.endpoints = []
        self.children_namespaces = []
      end

      def add_anonymous_children_namespace
        anonymous_namespace = Namespace.new('')
        anonymous_namespace.parent_namespace = self
        children_namespaces << anonymous_namespace
        anonymous_namespace
      end

      def add_endpoint(endpoint)
        endpoint.namespace = self
        endpoints << endpoint
        endpoint
      end

      def get_endpoint(endpoint_name)
        search_internal_endpoint(endpoint_name) || search_child_endpoint(endpoint_name)
      end

      def all_endpoints
        endpoints + children_namespaces.map { |ns| ns.all_endpoints }.flatten
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

      attr_writer :name, :endpoints

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
  end
end
