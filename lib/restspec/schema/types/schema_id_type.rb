module Restspec::Schema::Types
  class SchemaIdType < BasicType

    def initialize(schema_name, options = {})
      self.schema_name = schema_name
      super(options)
    end

    def example_for(attribute)
      return sample_item[id_property] if sample_item.present?

      if create_response.code == 201 && create_response.body[id_property].present?
        create_response.body[id_property]
      else
        hardcoded_fallback
      end
    rescue URI::InvalidURIError, Errno::ECONNREFUSED => e
      hardcoded_fallback
    end

    def valid?(attribute, value)
      return true unless perform_validation?
      item_ids.any? { |item| item[id_property] == value }
    end

    private

    attr_accessor :schema_name

    def find_endpoint(name)
      Restspec::EndpointStore.get(name)
    end

    def sample_item
      @sample_item ||= get_sample_item
    end

    def get_index_endpoint
      if schema_name.present?
        Restspec::EndpointStore.get_by_schema_name_and_role(schema_name, :index, :response)
      else
        find_endpoint(example_options.fetch(:fetch_endpoint))
      end
    end

    def get_sample_item
      fetch_endpoint = get_index_endpoint
      if fetch_endpoint.present?
        fetch_endpoint.execute.body.try(:sample)
      end
    end

    def create_response
      if create_endpoint.present?
        create_endpoint.execute(body: create_example)
      end
    end

    def get_create_endpoint
      if schema_name.present?
        Restspec::EndpointStore.get_by_schema_name_and_role(schema_name, :create, :payload)
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
      example_options.fetch(:create_schema) { create_endpoint.schema_for(:payload).name }
    end

    def perform_validation?
      schema_options.fetch(:perform_validation, true)
    end

    def id_property
      example_options.fetch(:id) { schema_options.fetch(:id, :id) }
    end

    def item_ids
      fetch_endpoint = get_index_endpoint
      fetch_endpoint.execute.body
    end

    def hardcoded_fallback
      example_options.fetch(:hardcoded_fallback, Faker::Number.digit)
    end
  end
end
