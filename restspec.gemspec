# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'restspec/version'

Gem::Specification.new do |spec|
  spec.name          = "restspec"
  spec.version       = Restspec::VERSION
  spec.authors       = ["juliogarciag"]
  spec.email         = ["julioggonz@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_dependency "activesupport", "~> 4.0"
  spec.add_dependency "hashie", "~> 3.3"
  spec.add_dependency "rack", "~> 1.0"
  spec.add_dependency "rspec", "~> 3.0"
  spec.add_dependency "httparty", "~> 0.13"
  spec.add_dependency "rspec-its", "~> 1.0"
  spec.add_dependency "rspec-collection_matchers", "~> 1.0"
end
