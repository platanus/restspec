module Restspec
  module Schema
    # A schema is a collection of attributes that defines how the data passed through the API
    # should be formed. In REST, they are the representation of the resources the REST API
    # returns.
    class Schema
      # The schema identifier.
      attr_reader :name

      # The set of attributes that conforms the schema.
      attr_reader :attributes

      # TODO: Document
      attr_accessor :intention
      attr_accessor :original_schema

      # @param name [Symbol] The name of the schema
      # @return a new {Restspec::Schema::Schema Schema} object
      def initialize(name)
        self.name = name
        self.attributes = {}
      end

      # @param without [Array] An array of attributes that should be removed from the schema.
      #   This shouldn't be used without cloning first, to avoid modifying a schema
      #   used elsewhere.
      def extend_with(without: [])
        without.each { |attribute_name| attributes.delete(attribute_name.to_s) }
        self
      end

      def attributes_for_intention
        return attributes if intention.blank?

        attributes.inject({}) do |hash, (name, attribute)|
          attribute.can?(intention) ? hash.merge(name => attribute) : hash
        end
      end

      private

      attr_writer :name, :attributes
    end
  end
end
