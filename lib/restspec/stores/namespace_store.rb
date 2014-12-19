require 'delegate'

module Restspec
  module Stores
    class NamespaceStoreDelegator < SimpleDelegator
      def store(namespace)
        self << namespace
      end

      def get(namespace_name)
        possible_names = [namespace_name.to_s, namespace_name.to_sym]
        find { |ns| possible_names.include?(ns.name) }
      end
    end

    NamespaceStore = NamespaceStoreDelegator.new(Array.new)
  end

  NamespaceStore = Stores::NamespaceStore
end
