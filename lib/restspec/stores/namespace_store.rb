require 'delegate'

module Restspec
  module Stores
    class NamespaceStoreDelegator < SimpleDelegator
      def store(namespace)
        self << namespace
      end

      def get(namespace_name)
        find { |ns| ns.name == namespace_name }
      end
    end

    NamespaceStore = NamespaceStoreDelegator.new(Array.new)
  end

  NamespaceStore = Stores::NamespaceStore
end
