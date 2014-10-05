module Restspec
  module Network
    def self.request(method, url, headers = {}, body = {})
      response = do_request(method, url, headers, body)
      Restspec::Response.new(response)
    end

    def self.do_request(method, url, headers = {}, body = {})
      HTTParty.send method, url, headers: headers, body: body.to_json
    end
  end
end
