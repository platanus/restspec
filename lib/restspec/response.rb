require 'delegate'

module Restspec
  class Response < SimpleDelegator
    attr_accessor :endpoint

    def inspect
      "[#{endpoint.method} to #{endpoint.path}]"
    end

    def read_body(parsed_body = parsed_body)
      if parsed_body.is_a?(Array)
        parsed_body.map do |item|
          read_body(item)
        end
      else
        SuperHash.new(parsed_body)
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
