require 'delegate'

module Restspec
  module Stores
    class NamespaceStoreDelegator < SimpleDelegator
      def store(namespace)
        self[namespace.name] = namespace
      end
    end

    NamespaceStore = NamespaceStoreDelegator.new(Hash.new)
  end

  NamespaceStore = Stores::NamespaceStore
end
