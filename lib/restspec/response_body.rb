require 'hashie'

module Restspec
  class ResponseBody < Hash
    include Hashie::Extensions::MethodAccess
    include Hashie::Extensions::IndifferentAccess
    include Hashie::Extensions::MergeInitializer

    def self.from_raw_body(raw_body)
       new(parse_raw_body(raw_body))
    end

    def self.parse_raw_body(raw_body)
      JSON.parse(raw_body)
    end
  end
end
