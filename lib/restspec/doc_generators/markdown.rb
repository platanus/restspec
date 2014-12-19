module Restspec
  module DocGenerators
    class Markdown
      attr_reader :markdown_string

      def initialize
        self.markdown_string = ''
      end

      def generate
        generate_app_header

        ns_store.each do |ns|
          markdown_string << "## #{ns.name.capitalize}\n"
          generate_endpoints(ns)
          markdown_string << "\n"
        end

        markdown_string
      end

      private

      attr_writer :markdown_string

      def generate_app_header
        markdown_string << "# API\n\n"
      end

      def generate_endpoints(ns)
        ns.all_endpoints.each do |endpoint|
          markdown_string << "### #{endpoint.name.capitalize} [#{endpoint.method.upcase} #{endpoint.full_path}]\n"
          markdown_string << "Returns schema **#{endpoint.schema_name}**:\n"

          generate_schema_table(endpoint.schema_name)
        end
      end

      def generate_schema_table(schema_name)
        schema = schema_store.get(schema_name)

        markdown_string << "
| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
#{
  schema.attributes.map do |name, attribute|
    "| #{name} | #{attribute.type.to_s} | #{attribute.type.example_for(attribute)} |"
  end.join("\n")
}\n\n"
      end

      def ns_store
        Restspec::NamespaceStore.uniq { |ns| ns.name }
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
