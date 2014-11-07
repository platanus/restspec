module Restspec
  module Schema
    class Attribute < Struct.new(:name, :type, :options)
      def example
        @example ||= options[:example]
      end
    end
  end
end
