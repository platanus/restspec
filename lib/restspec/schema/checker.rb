module Restspec
  module Schema
    class Checker < Struct.new(:schema)
      def check!(body)
        if body.is_a?(Array)
          body.each { |item| check!(item) }
        else
          check_object(body)
        end

        return true
      end

      private

      def check_object(object)
        schema.attributes.each do |_, attribute|
          checker = ObjectChecker.new(object, attribute)
          
          raise NoAttributeError.new(object, attribute) if checker.missed_key?
          raise DifferentTypeError.new(object, attribute, value) if checker.wrong_type?
        end
      end

      class ObjectChecker < Struct.new(:object, :attribute)
        def missed_key?
          !object.has_key?(attribute.name)
        end

        def wrong_type?
          object.fetch(attribute.name).class != attribute.type
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

        def initialize(object, attribute, value)
          self.object = object
          self.attribute = attribute
          self.value = value
        end

        def to_s
          "The property #{attribute.name} of #{object} should be of type #{attribute.type} but it was of type #{value.class}"
        end
      end
    end
  end  
end
