module Restspec
  module Values
    class StatusCode < Struct.new(:number_or_symbol)
      def value
        if number_or_symbol.is_a?(Symbol)
          Rack::Utils::SYMBOL_TO_STATUS_CODE.fetch(number_or_symbol)
        else
          number_or_symbol
        end
      end
    end
  end
end
