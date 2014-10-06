require 'faker'

module Restspec
  module Schema
    class AttributeExample < Struct.new(:type)
      def value
        if type == String
          Faker::Lorem.word
        else
          raise "we don't know how to build an example for an object of class #{type}"
        end
      end
    end
  end
end
