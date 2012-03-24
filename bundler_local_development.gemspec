# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bundler_local_development/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nathan Broadbent"]
  gem.email         = ["nathan.f77@gmail.com"]
  gem.description   = %q{Provides a simple way to switch between local and installed gems.}
  gem.summary       = %q{Switch to a set of local gems with a single command}
  gem.homepage      = "https://github.com/ndbroadbent/bundler_local_development"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "bundler_local_development"
  gem.require_paths = ["lib"]
  gem.version       = BundlerLocalDevelopment::VERSION

  gem.add_dependency 'bundler'
end
