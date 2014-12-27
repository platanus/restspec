module Restspec
  module Schema
    # Checks if a response object (a hash, esentially) is valid against
    # a schema.
    class Checker
      # Creates a new {Checker} using a {Schema} object.
      def initialize(schema)
        self.schema = schema
      end

      # Checks iteratively through an array of objects.
      def check_array!(array)
        array.each { |item| check!(item) }
      end

      # Checks if an object follows the contract provided by
      # the schema. This will just pass through if everything is ok.
      # If something is wrong, an error will be raised. The actual check
      # will be done, attribute by attribute, by an instance of {ObjectChecker},
      # calling the methods {ObjectChecker#check_missed_key! check_missed_key!} and
      # {ObjectChecker#check_invalid! check_invalid!}.
      #
      # @param object [Hash] the object to check against the schema.
      # @raise NoObjectError if parameter passed is not a hash.
      def check!(object)
        raise NoObjectError.new(object) unless object.is_a?(Hash)

        schema.attributes.each do |_, attribute|
          if attribute.can_be_checked?
            checker = ObjectChecker.new(object, attribute)
            checker.check_missed_key!
            checker.check_invalid!
          end
        end
      end

      private

      attr_accessor :schema

      # Checks an object against a schema's attribute
      # definition.
      class ObjectChecker
        def initialize(object, attribute)
          self.object = object
          self.attribute = attribute
        end

        # Checks if the attribute's key is absent from the object.
        #
        # @example
        #   # Given the following schema
        #   schema :product do
        #     attribute :name, string
        #   end
        #
        #   ObjectChecker.new({ age: 10 }, schema.attributes[:name]).missed_key?
        #   # true
        #   ObjectChecker.new({ name: 'John' }, schema.attributes[:name]).missed_key?
        #   # false
        #
        # @return [true, false] If the attribute's key is absent from the object
        def missed_key?
          !object.has_key?(attribute.name)
        end

        # Calls {#missed_key?} and if the call is true, raises
        # a {NoAttributeError}.
        def check_missed_key!
          raise NoAttributeError.new(object, attribute) if missed_key?
        end

        # Checks if the attribute's type validation fails
        # with the object' attribute. To do this, the #valid? method
        # of the type is executed.
        #
        # @example
        #   # Given the following schema
        #   schema :product do
        #     attribute :name, string
        #   end
        #
        #   ObjectChecker.new({ name: 10 }, schema.attributes[:name]).invalid?
        #   # true
        #   ObjectChecker.new({ name: 'John' }, schema.attributes[:name]).invalid?
        #   # false
        #
        # @return [true, false] If the attribute's type validation fails
        #   with the object' attribute.
        def invalid?
          !attribute.type.totally_valid?(attribute, object.fetch(attribute.name))
        end

        # Calls {#invalid?} and if the call is true, raises
        # a {InvalidationError}.
        def check_invalid!
          raise InvalidationError.new(object, attribute) if invalid?
        end

        private

        attr_accessor :object, :attribute
      end

      class NoAttributeError < StandardError
        attr_accessor :object, :attribute

        def initialize(object, attribute)
          self.object = object
          self.attribute = attribute
        end

        def to_s
          "The object #{object} does not have the attribute #{attribute.name}"
        end
      end

      class InvalidationError < StandardError
        attr_accessor :object, :attribute, :value

        def initialize(object, attribute)
          self.object = object
          self.attribute = attribute
          self.value = object.fetch(attribute.name)
        end

        def to_s
          "The property #{attribute.name} of #{object} was not valid according to the type #{attribute.type}"
        end
      end

      class NoObjectError < StandardError
        attr_accessor :object

        def initialize(object)
          self.object = object
        end

        def to_s
          "The object #{object}:#{object.class} is not a hash. It doesn't have attributes to be checked"
        end
      end
    end
  end
end
