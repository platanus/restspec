require 'active_support/configurable'

module Restspec
  include ActiveSupport::Configurable

  class << self
    def configure
      config.request = OpenStruct.new(headers: {})

      yield config
    end
  end
end
