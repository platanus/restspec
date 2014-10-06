require "restspec/version"

module Restspec
  # Your code goes here...
end

require 'active_support/core_ext/object'
require "restspec/values/status_code"
require "restspec/values/super_hash"
require "restspec/configuration"
require "restspec/schema_definitions"
require "restspec/response"
require "restspec/network"
require "restspec/endpoint"
require "restspec/namespace"

require "restspec/rspec/extras"
require "restspec/rspec/api_helpers"
require "restspec/rspec/api_macros"
