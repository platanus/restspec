module Restspec
  module Schema
    class Finder
      def find(name)
        schema_store.get(name)
      end

      private

      def schema_store
        Restspec::SchemaStore
      end
    end
  end
end
