require 'active_support/concern'

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
          schema_roles[role] = Restspec::SchemaStore.fetch(schema_name).clone
          if options.any?
            schema_roles[role].extend_with(options)
          end
        end
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
