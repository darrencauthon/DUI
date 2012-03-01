# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "DUI/version"

Gem::Specification.new do |s|
  s.name        = "DUI"
  s.version     = DUI::VERSION
  s.authors     = ["Darren Cauthon"]
  s.email       = ["darren@cauthon.com"]
  s.homepage    = "http://www.github.com/darrencauthon/DUI"
  s.summary     = %q{Easier syncing with Delete - Update - Insert}
  s.description = %q{This gem provides a small API for comparing two datasets, 
                     for determining what records should be deleted, updated, or inserted.}

  s.rubyforge_project = "DUI"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
  s.add_runtime_dependency "hashie"
end
