require 'hashie'

module Restspec
  module Values
    class SuperHash < Hash
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::IndifferentAccess
      include Hashie::Extensions::MergeInitializer
    end
  end
end
