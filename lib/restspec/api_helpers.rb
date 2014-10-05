require 'active_support/core_ext/object'

module Restspec
  module ApiHelpers
    def read_endpoint(endpoint_full_name = nil)
      if endpoint_full_name.present?
        endpoint = Namespace.get_by_full_name(endpoint_full_name)
        endpoint.execute.read_body
      else
        @endpoint.execute.read_body
      end
    end
  end
end
