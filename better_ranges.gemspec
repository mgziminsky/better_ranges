# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'better_ranges/version'

Gem::Specification.new do |spec|
  spec.name          = 'better_ranges'
  spec.version       = BetterRanges::VERSION
  spec.authors       = ['Michael Ziminsky']
  spec.email         = ['mgziminsky@gmail.com']
  spec.summary       = 'Add support for set operations to the ruby Range class'
  spec.homepage      = 'https://github.com/mgziminsky/better_ranges'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.8.6'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
