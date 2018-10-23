# -*- encoding: utf-8 -*-
# stub: sinatra-advanced-routes 0.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sinatra-advanced-routes".freeze
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Konstantin Haase".freeze]
  s.date = "2010-04-16"
  s.description = "Make Sinatra routes first class objects (part of BigBand).".freeze
  s.email = "konstantin.mailinglists@googlemail.com".freeze
  s.homepage = "http://github.com/rkh/sinatra-advanced-routes".freeze
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Make Sinatra routes first class objects (part of BigBand).".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<monkey-lib>.freeze, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<sinatra-sugar>.freeze, ["~> 0.4.0"])
      s.add_development_dependency(%q<sinatra-test-helper>.freeze, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<sinatra>.freeze, [">= 0.9.4"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 1.3.0"])
    else
      s.add_dependency(%q<monkey-lib>.freeze, ["~> 0.4.0"])
      s.add_dependency(%q<sinatra-sugar>.freeze, ["~> 0.4.0"])
      s.add_dependency(%q<sinatra-test-helper>.freeze, ["~> 0.4.0"])
      s.add_dependency(%q<sinatra>.freeze, [">= 0.9.4"])
      s.add_dependency(%q<rspec>.freeze, [">= 1.3.0"])
    end
  else
    s.add_dependency(%q<monkey-lib>.freeze, ["~> 0.4.0"])
    s.add_dependency(%q<sinatra-sugar>.freeze, ["~> 0.4.0"])
    s.add_dependency(%q<sinatra-test-helper>.freeze, ["~> 0.4.0"])
    s.add_dependency(%q<sinatra>.freeze, [">= 0.9.4"])
    s.add_dependency(%q<rspec>.freeze, [">= 1.3.0"])
  end
end
