require 'httparty'

module Restspec
  module Endpoints
    class Endpoint < Struct.new(:name)
      attr_accessor :method, :path, :namespace, :raw_url_params
      attr_writer :schema_name
      attr_reader :executed_url

      PARAM_INTERPOLATION_REGEX = /:([\w]+)/

      def execute(body: {}, url_params: {}, query_params: {})
        full_url_params = self.url_params.merge(url_params)
        full_url = build_url(full_url_params, query_params)

        Network.request(method, full_url, full_headers, body).tap do |response|
          self.executed_url = full_url
          response.endpoint = self
        end
      end

      def full_name
        [namespace.try(:name), name].compact.join("/")
      end

      def schema_name
        @schema_name || namespace.actual_schema_name
      end

      def schema
        @schema ||= Restspec::Schema::Finder.new.find(schema_name)
      end

      def full_path
        if namespace && in_member_or_collection?
          "#{namespace.full_base_path}#{path}"
        else
          path
        end
      end

      def headers
        @headers ||= {}
      end

      def url_params
        @url_params ||= Restspec::Values::SuperHash.new(calculate_url_params)
      end

      def add_url_param_block(param, &block)
        raw_url_params[param] = Proc.new(&block)
      end

      private

      attr_writer :executed_url

      def raw_url_params
        @raw_url_params ||= Restspec::Values::SuperHash.new
      end

      def in_member_or_collection?
        namespace.anonymous?
      end

      def calculate_url_params
        raw_url_params.inject({}) do |hash, (key, value)|
          real_value = if value.respond_to?(:call)
            value.call
          else
            value
          end

          hash.merge(key => real_value)
        end
      end

      def build_url(full_url_params, query_params)
        query_string = query_params.to_param
        full_query_string = query_string ? "?#{query_string}" : ""

        base_url + path_from_params(full_url_params) + full_query_string
      end

      def path_from_params(url_params)
        full_path.gsub(PARAM_INTERPOLATION_REGEX) do
          url_params[$1] || url_params[$1.to_sym]
        end
      end

      def full_headers
        config_headers.merge(headers)
      end

      def config_headers
        Restspec.config.request.headers
      end

      def base_url
        @base_url ||= (Restspec.config.base_url || '')
      end
    end
  end
end
