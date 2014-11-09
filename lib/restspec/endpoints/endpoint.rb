require 'httparty'

module Restspec
  module Endpoints
    class Endpoint < Struct.new(:name)
      attr_accessor :method, :path, :namespace, :url_params
      attr_writer :schema_name

      def execute(body: {}, url_params: {}, query_params: {})
        full_url_params = self.url_params.merge(url_params)
        full_url = build_url(full_url_params, query_params)
        Network.request(method, full_url, full_headers, body).tap do |response|
          response.endpoint = self
        end
      end

      def full_name
        "#{namespace.name}/#{name}"
      end

      def execute_once(body: {}, url_params: {}, query_params: {})
        @saved_execution ||= execute(body: body, url_params: url_params, query_params: query_params)
      end

      def schema_name
        @schema_name || namespace.actual_schema_name
      end

      def schema
        @schema ||= Restspec::Schema::Finder.new.find(schema_name)
      end

      def full_path
        if in_member_or_collection?
          "#{namespace.full_base_path}#{path}"
        else
          path
        end
      end

      def in_member_or_collection?
        namespace[:name].blank?
      end

      def headers
        @headers ||= {}
      end

      def url_params
        @url_params ||= {}
      end

      private

      def build_url(url_params, query_params)
        query_string = query_params.to_param
        full_query_string = query_string ? "?#{query_string}" : ""

        base_url + path_from_params(url_params) + full_query_string
      end

      def path_from_params(url_params)
        full_path.gsub(/:([\w]+)/) do
          param_value = url_params[$1] || url_params[$1.to_sym]
          
          if param_value.is_a?(Proc)
            param_value.call
          else
            param_value
          end
        end
      end

      def full_headers
        config_headers.merge(headers)
      end

      def config_headers
        Restspec.config.request.headers
      end

      def base_url
        @base_url ||= detect_base_url
      end

      def detect_base_url
        Restspec.config.base_url
      end
    end
  end
end
