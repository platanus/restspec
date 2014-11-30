module Restspec::Schema::Types
  class SchemaIdType < BasicType
    attr_accessor :schema_name

    def initialize(options)
      if options.is_a?(Symbol)
        self.schema_name = options
        super({})
      else
        super
      end
    end

    def example_for(attribute)
      if sample_item.present?
        sample_item.id
      else
        if create_response.code == 201 && create_response.body.id
          create_response.body.id
        else
          example_options.fetch(:hardcoded_fallback) {
            raise "We couldn't fetch any information for this example"
          }
        end
      end
    end

    def valid?(attribute, value)
      return true unless perform_validation?
      item_ids.any? { |item| item.id == value }
    end

    private

    def find_endpoint(name)
      finder.find(name)
    end

    def finder
      @finder ||= Restspec::Endpoints::Finder.new
    end

    def sample_item
      @sample_item ||= get_sample_item
    end

    def get_index_endpoint
      if schema_name.present?
        namespace = Restspec::Endpoints::Namespace.get_by_schema_name(schema_name)
        namespace.get_endpoint(:index)
      else
        find_endpoint(example_options.fetch(:fetch_endpoint))
      end
    end

    def get_sample_item
      fetch_endpoint = get_index_endpoint
      fetch_endpoint.execute.body.try(:sample)
    end

    def create_response
      create_endpoint.execute(body: create_example)
    end

    def get_create_endpoint
      if schema_name.present?
        namespace = Restspec::Endpoints::Namespace.get_by_schema_name(schema_name)
        namespace.get_endpoint(:create)
      else
        find_endpoint(example_options.fetch(:create_endpoint))
      end
    end

    def create_endpoint
      @create_endpoint ||= get_create_endpoint
    end

    def create_example
      Restspec.example_for(create_schema_name)
    end

    def create_schema_name
      example_options.fetch(:create_schema, create_endpoint.schema_name)
    end

    def perform_validation?
      schema_options.fetch(:perform_validation, true)
    end

    def item_ids
      fetch_endpoint = get_index_endpoint
      fetch_endpoint.execute.body
    end
  end
end
