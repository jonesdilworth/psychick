# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'psychick/version'

Gem::Specification.new do |gem|
  gem.name          = "psychick"
  gem.version       = Psychick::VERSION
  gem.authors       = ["Corey Ward"]
  gem.email         = ["corey.atx@gmail.com"]
  gem.description   = %q{Psychick predicts alternate URLs for a given page}
  gem.summary       = %q{Psychick augments a URL in a variety of ways that are likely to produce valid alternates for the same resource.}
  gem.homepage      = "http://github.com/jonesdilworth/psychick"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'active_support'
end
