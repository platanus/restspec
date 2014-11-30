require 'delegate'

module Restspec
  module Stores
    class NamespaceStoreDelegator < SimpleDelegator
      # For future changes
    end

    NamespaceStore = NamespaceStoreDelegator.new(Hash.new)
  end

  NamespaceStore = Stores::NamespaceStore
end
