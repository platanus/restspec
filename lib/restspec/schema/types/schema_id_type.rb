require 'pry'

module Restspec::Schema::Types
  class SchemaIdType < BasicType
    def example_for(attribute)
      # TODO: Refactor!!!!!
      fetch_endpoint_name = example_options.fetch(:fetch_endpoint)
      create_endpoint_name = example_options.fetch(:create_endpoint)

      fetch_endpoint = find_endpoint(fetch_endpoint_name)
      create_endpoint = find_endpoint(create_endpoint_name)

      fetch_data = fetch_endpoint.execute.read_body
      sample_item = fetch_data.sample

      if sample_item.present?
        sample_item.id
      else
        create_schema_name = example_options.fetch(:create_schema)
        create_example = Restspec.example_for(create_schema_name)

        create_response = create_endpoint.execute(body: create_example)

        if create_response.code == 201
          new_item = create_response.read_body
          if new_item.present?
            new_item.id
          else
            example_options.fetch(:hardcoded_fallback)
          end
        else
          example_options.fetch(:hardcoded_fallback)
        end
      end
    end

    def valid?(attribute, value)
      # TODO: Refactor!
      perform_validation = schema_options.fetch(:perform_validation, true)

      if perform_validation
        fetch_endpoint_name = schema_options.fetch(:fetch_endpoint)
        fetch_endpoint = find_endpoint(fetch_endpoint_name)

        item_ids = fetch_endpoint.execute.read_body

        item_ids.any? do |item|
          item.id == value
        end
      else
        true
      end
    end

    private

    def find_endpoint(name)
      Restspec::Endpoints::Namespace.get_by_full_name(name)
    end
  end
end
