module Restspec
  module Endpoints
    class Request < Struct.new(:method, :url, :headers, :payload)
      attr_accessor :endpoint

      def raw_payload
        @raw_payload ||= (payload || '').to_json
      end
    end
  end
end
