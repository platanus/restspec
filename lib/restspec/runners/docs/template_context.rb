module Restspec
  module Docs
    class TemplateContext
      def namespace_store
        Restspec::NamespaceStore
      end

      def endpoints_store
        Restspec::EndpointStore
      end

      def schema_store
        Restspec::SchemaStore
      end

      def json_example(schema)
        sample = Restspec::Schema::SchemaExample.new(schema).value
        JSON.pretty_generate(sample).gsub(/^/, '  ')
      end

      def json_example_code(schema)
        "<div class=\"highlight highlight-json\">
          <pre><code>#{json_example(schema)}</pre></code>
        </div>"
      end
    end
  end
end
