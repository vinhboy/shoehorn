# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "shoehorn/version"

Gem::Specification.new do |s|
  s.name        = "shoehorn"
  s.version     = Shoehorn::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Gunderloy"]
  s.email       = ["MikeG1@larkfarm.com"]
  s.homepage    = "https://github.com/ffmike/shoehorn"
  s.summary     = %q{Shoeboxed API implementation}
  s.description = %q{Ruby implementation of the API for Shoeboxed, http://developer.shoeboxed.com/overview}

  s.rubyforge_project = "shoehorn"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
