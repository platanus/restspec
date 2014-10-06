module Restspec
  module Network
    extend self

    def request(method, url, headers = {}, body = {})
      response = do_request(method, url, headers, body)
      Restspec::Response.new(response)
    end

    def do_request(method, url, headers = {}, body = {})
      HTTParty.send method, url, headers: headers, body: body.to_json
    end
  end
end
