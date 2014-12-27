module Restspec
  module Values
    # A value object that transforms a http status code (201) or
    # a symbol with the status code message (:created) to a simple
    # number (201).
    class StatusCode
      def initialize(number_or_symbol)
        self.number_or_symbol = number_or_symbol
      end

      # @example
      #   StatusCode.new(201).value # 201
      #   StatusCode.new(:created).value # 201
      # @return [Fixnum] the status code
      def value
        if number_or_symbol.is_a?(Symbol)
          Rack::Utils::SYMBOL_TO_STATUS_CODE.fetch(number_or_symbol)
        else
          number_or_symbol
        end
      end

      private

      attr_accessor :number_or_symbol
    end
  end
end
