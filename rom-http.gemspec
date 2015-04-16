# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/http/version'

Gem::Specification.new do |spec|
  spec.name          = 'rom-http'
  spec.version       = ROM::HTTP::VERSION
  spec.authors       = ['Chris Keele']
  spec.email         = ['dev@chriskeele.com']
  spec.summary       = 'HTTP support for ROM.'
  spec.description   = 'A ROM adapter that allows you to consume, transform, and even persist to external HTTP APIs.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'http', '~> 0.8.0'
  spec.add_runtime_dependency 'rom', '~> 0.6.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.28.0'
end
