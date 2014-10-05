require 'httparty'

module Restspec
  class Endpoint < Struct.new(:name, :method, :path, :namespace)
    def execute(body = {})
      Restspec::Network.request(method, url, headers, body).tap do |response|
        response.endpoint = self
      end
    end

    def full_name
      "#{namespace.name}/#{name}"
    end

    def execute_once(body: {})
      @saved_execution ||= execute(body)
    end

    private

    def headers
      Restspec.config.request.headers
    end

    def url
      base_url + path
    end

    def base_url
      @base_url ||= detect_base_url
    end

    def detect_base_url
      Restspec.config.base_url
    end
  end
end
