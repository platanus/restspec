require 'delegate'

module Restspec
  module Stores
    # Provides methods for the {NamespaceStore} object.
    class NamespaceStoreDelegator < SimpleDelegator
      # Stores the namespace. It uses the namespace's name as the hash key.
      #
      # @param namespace [Restspec::Endpoints::Namespace] the namespace to store.
      # @raise [StandardError] if the namespace is an anonymous one.
      def store(namespace)
        if namespace.anonymous?
          raise "Can't add an anonymous namespace to the NamespaceStore"
        else
          self[namespace.name] = namespace
        end
      end

      # Get a namespace by name. It gets the name as string or symbol.
      #
      # @param namespace_name [String, Symbol] the namespace's name to use for search.
      # @return [Restspec::Endpoints::Namespace, nil] the namespace found.
      def get(namespace_name)
        fetch(namespace_name.to_s) { fetch(namespace_name.to_sym, nil) }
      end
    end

    # The Namespace Store is a Hash extended using {Stores::NamespaceStoreDelegator}
    # This is where we store the namespaces of the API.
    #
    # It's important to note that, because this is a Hash, there can't be
    # two namespaces with the same name. Anonymous namespaces can't be stored
    # here. They are just stored as children of each namespace.
    NamespaceStore = NamespaceStoreDelegator.new(Hash.new)
  end

  # (see Stores::NamespaceStore)
  NamespaceStore = Stores::NamespaceStore
end
