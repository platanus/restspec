module Restspec
  module DocGenerators
    class Markdown
      def generate
        template_file = Pathname.new(File.dirname(__FILE__)).join('templates/doc_api.md.erb')
        ERB.new(File.read(template_file)).result(binding)
      end

      private

      def namespace_store
        Restspec::NamespaceStore
      end

      def endpoints_store
        Restspec::EndpointStore
      end

      def schema_store
        Restspec::SchemaStore
      end
    end
  end
end
