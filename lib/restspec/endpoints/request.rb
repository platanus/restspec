module Restspec
  module Endpoints
    # A bag for request data.
    class Request < Struct.new(:method, :url, :headers, :payload)
      # Allows to set the endpoint used to generate this request.
      attr_accessor :endpoint

      # @return [String] a json encoded payload
      def raw_payload
        @raw_payload ||= (payload || '').to_json
      end
    end
  end
end
