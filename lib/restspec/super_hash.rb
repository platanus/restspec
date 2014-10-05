require 'hashie'

module Restspec
  class SuperHash < Hash
    include Hashie::Extensions::MethodAccess
    include Hashie::Extensions::IndifferentAccess
    include Hashie::Extensions::MergeInitializer
  end
end
