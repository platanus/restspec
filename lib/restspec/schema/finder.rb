module Restspec
  module Schema
    class Finder
      def find(name)
        schemas.fetch(name)
      end

      private

      def schemas
        Restspec.dsl.schemas || {}
      end
    end
  end
end
