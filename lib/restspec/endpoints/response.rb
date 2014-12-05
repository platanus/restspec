require 'delegate'

module Restspec
  module Endpoints
    class Response
      attr_accessor :endpoint, :headers, :code, :raw_body

      def initialize(code, headers, raw_body)
        self.headers = headers
        self.code = code
        self.raw_body = raw_body
      end

      def to_s
        if endpoint.present?
          url = endpoint.executed_url || endpoint.full_path
          "[#{endpoint.method.upcase} to #{url}]"
        else
          raw_body
        end
      end

      def read_body(value = parsed_body)
        case value
        when Array
          value.map { |item| read_body(item) }
        when Hash
          Values::SuperHash.new(value).tap do |super_hash|
            super_hash.find do |key, value|
              if value.class == Array
                super_hash[key] = read_body(value)
              end
            end
          end
        else
          value
        end
      end

      def parsed_body
        @parsed_body ||= begin
          JSON.parse(raw_body)
        rescue JSON::ParserError => e
          raw_body
        end
      end

      def body
        @body ||= read_body
      end
    end
  end
end
