# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "udon/version"

Gem::Specification.new do |s|
  s.name        = "udon"
  s.version     = Udon::VERSION
  s.authors     = ["Joseph Wecker"]
  s.email       = ["joseph.wecker@gmail.com"]
  s.homepage    = "udon.io"
  s.summary     = %q{Universal Document and Object Notation}
  s.description = %q{TODO}

  s.rubyforge_project = "udon"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
