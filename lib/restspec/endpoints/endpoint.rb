require 'httparty'

module Restspec
  module Endpoints
    class Endpoint < Struct.new(:name)
      attr_accessor :method, :path, :namespace

      def execute(body: {}, query_params: query_params)
        full_url = build_url(query_params)
        Network.request(method, full_url, headers, body).tap do |response|
          response.endpoint = self
        end
      end

      def full_name
        "#{namespace.name}/#{name}"
      end

      def execute_once(body: {}, query_params: {})
        @saved_execution ||= execute(body: body, query_params: query_params)
      end

      def schema_name
        namespace.schema_name
      end

      def schema
        @schema ||= Restspec::Schema::Finder.new.find(schema_name)
      end

      private

      def build_url(query_params)
        if query_params.empty?
          base_url + path
        else
          base_url + path.gsub(/:([\w]+)/) { query_params[$1] }
        end
      end

      def headers
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
