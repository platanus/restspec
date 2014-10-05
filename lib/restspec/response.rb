require 'delegate'

module Restspec
  class Response < SimpleDelegator
    attr_accessor :endpoint

    def inspect
      "[#{endpoint.method} to #{endpoint.path}]"
    end

    def read_body
      SuperHash.from_raw_body(raw_body)
    end

    def raw_body
      __getobj__.body
    end

    alias_method :body, :read_body
  end
end
