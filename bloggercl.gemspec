# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bloggercl/version"

Gem::Specification.new do |s|
  s.name        = "bloggercl"
  s.version     = BloggerCL::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Yoshihiro Hara"]
  s.email       = ["hara@hxa.jp"]
  s.homepage    = ""
  s.summary     = %q{Blogger client script}
  s.description = %q{bloggercl is a script to post articles to Blogger.}

  s.rubyforge_project = "bloggercl"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'thor'
  s.add_dependency 'oauth'
  s.add_dependency 'kramdown'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rcov'
  s.add_development_dependency 'autotest'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'webmock'
end
