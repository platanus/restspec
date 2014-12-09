module Restspec
  module Schema
    class Checker < Struct.new(:schema)
      def check_array!(array)
        array.each { |item| check!(item) }
      end

      def check!(object)
        raise NoObjectError.new(object) unless object.is_a?(Hash)

        schema.attributes.each do |_, attribute|
          if attribute.can_be_checked?
            checker = ObjectChecker.new(object, attribute)

            raise NoAttributeError.new(object, attribute) if checker.missed_key?
            raise DifferentTypeError.new(object, attribute) if checker.wrong_type?
          end
        end
      end

      private

      class ObjectChecker < Struct.new(:object, :attribute)
        def missed_key?
          !object.has_key?(attribute.name)
        end

        def wrong_type?
          !attribute.type.totally_valid?(attribute, object.fetch(attribute.name))
        end
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

      class DifferentTypeError < StandardError
        attr_accessor :object, :attribute, :value

        def initialize(object, attribute)
          self.object = object
          self.attribute = attribute
          self.value = object.fetch(attribute.name)
        end

        def to_s
          "The property #{attribute.name} of #{object} should be of type #{attribute.type} but it was of type #{value.class}"
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
