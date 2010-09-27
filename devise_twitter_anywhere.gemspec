# -*- encoding: utf-8 -*-
require File.expand_path("../lib/devise_twitter_anywhere/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "devise_twitter_anywhere"
  s.version     = DeviseTwitterAnywhere::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mateusz Drożdżyński"]
  s.email       = ["gems@objectreload.com"]
  s.homepage    = "http://github.com/objectreload/devise_twitter_anywhere"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "devise_twitter_anywhere"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_bundler_dependencies

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
