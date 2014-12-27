module Restspec
  module Endpoints
    class URLBuilder
      attr_reader :url_params

      PARAM_INTERPOLATION_REGEX = /:([\w]+)/

      def initialize(path = '', url_params = {}, query_params = {})
        self.path = path
        self.url_params = unbox_url_params(url_params)
        self.query_params = query_params
      end

      def full_url
        base_url + path_from_params + query_string
      end

      private

      attr_accessor :path, :query_params
      attr_writer :url_params

      def path_from_params
        path.gsub(PARAM_INTERPOLATION_REGEX) do
          url_params[$1] || url_params[$1.to_sym]
        end
      end

      def base_url
        @base_url ||= (Restspec.config.base_url || '')
      end

      def query_string
        @query_string ||= fill_query_string(query_params.to_param)
      end

      def fill_query_string(query_string)
        query_string.present? ? "?#{query_string}" : ""
      end

      def unbox_url_params(raw_url_params)
        params = raw_url_params.inject({}) do |hash, (key, value)|
          real_value = value.respond_to?(:call) ? value.call : value
          hash.merge(key.to_sym => real_value)
        end

        Restspec::Values::SuperHash.new(params)
      end
    end
  end
end
