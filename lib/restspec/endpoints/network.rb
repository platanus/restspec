module Restspec
  module Endpoints
    module Network
      extend self

      def request(method, url, headers = {}, body = {})
        response = do_request(method, url, headers, body)
        Response.new(response)
      end

      def do_request(method, url, headers = {}, body = {})
        HTTParty.send method, url, headers: headers, body: (body || '').to_json
      end
    end
  end
end
