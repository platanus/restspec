require 'active_support/concern'
require 'deep_clone'

module Restspec
  module Endpoints
    module HasSchemas
      extend ActiveSupport::Concern

      DEFAULT_ROLES = [:response]
      ROLES = [:response, :payload]

      def schema_roles
        @schema_roles ||= {}
      end

      def add_schema(schema_name, options)
        roles = options.delete(:for) || DEFAULT_ROLES

        roles.each do |role|
          schema_found = Restspec::SchemaStore.fetch(schema_name)

          schema_roles[role] = DeepClone.clone(schema_found)
          schema_roles[role].intention = role
          schema_roles[role].original_schema = schema_found

          if options.any?
            schema_roles[role].extend_with(options)
          end
        end
      end

      def all_schemas
        schema_roles.values
      end

      def remove_schemas
        schema_roles.clear
      end

      def schema_for(role_name)
        schema_roles[role_name]
      end
    end
  end
end
