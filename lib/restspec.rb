require "restspec/version"

module Restspec
end

require 'active_support/core_ext/object'
require 'active_support/json'

require "restspec/values/status_code"
require "restspec/values/super_hash"

require "restspec/configuration"
require "restspec/stores/namespace_store"
require "restspec/stores/endpoint_store"
require "restspec/stores/schema_store"
require "restspec/shortcuts"

require "restspec/schema/checker"
require "restspec/schema/types"
require "restspec/schema/attribute"
require "restspec/schema/attribute_example"
require "restspec/schema/schema_example"
require "restspec/schema/schema"
require "restspec/schema/dsl"

require "restspec/endpoints/dsl"
require "restspec/endpoints/request"
require "restspec/endpoints/response"
require "restspec/endpoints/network"
require "restspec/endpoints/endpoint"
require "restspec/endpoints/namespace"
require "restspec/endpoints/url_builder"

require "restspec/requirements/dsl"
require "restspec/requirements/requirement"

require "restspec/rspec/extras"
require "restspec/rspec/api_helpers"
require "restspec/rspec/api_macros"
require "restspec/rspec/shared_examples"
