require 'active_support/configurable'

module Restspec
  include ActiveSupport::Configurable

  class << self
    def configure
      # TODO: This is json specific, try to refactor
      config.request = OpenStruct.new(headers: {})
      config.request.headers['Content-Type'] = 'application/json'
      config.request.headers['Accept'] = 'application/json'

      yield config
    end
  end
end
