# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rulify/version'

Gem::Specification.new do |spec|
  spec.name          = "rulify"
  spec.version       = Rulify::VERSION
  spec.authors       = ["Vladimir Yarotsky"]
  spec.email         = ["vladimir.yarotsky@gmail.com"]
  spec.summary       = %q{Extensible, efficient rule engine for your app.}
  spec.homepage      = "https://github.com/v-yarotsky/rulify"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
