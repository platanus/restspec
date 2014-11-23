require 'delegate'

module Restspec
  module Endpoints
    class Response < SimpleDelegator
      attr_accessor :endpoint

      def to_s
        url = endpoint.executed_url || endpoint.full_path
        "[#{endpoint.method.upcase} to #{url}]"
      end

      def read_body(parsed_body = parsed_body)
        if parsed_body.is_a?(Array)
          parsed_body.map do |item|
            read_body(item)
          end
        else
          Values::SuperHash.new(parsed_body)
        end
      end

      def parsed_body
        @parsed_body ||= JSON.parse(raw_body)
      end

      def raw_body
        __getobj__.body
      end

      def body
        @body ||= read_body
      end
    end
  end
end
