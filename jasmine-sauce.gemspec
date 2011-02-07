# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jasmine-sauce}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eric Allen", "Chad Wooley"]
  s.date = %q{2011-02-07}
  s.summary = %q{Jasmine + Sauce OnDemand}
  s.description = %q{Adapter to run Jasmine tests using browsers in Sauce OnDemand}
  s.email = %q{eric@hackerengineer.net}
  s.files = [
    "LICENSE",
    "README.md",
    "Rakefile",
  ] + Dir.glob("lib/**/*")
  s.homepage = %q{http://github.com/saucelabs/jasmine-sauce}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.2}
  s.test_files = [
  ]

  s.add_runtime_dependency("sauce", [">= 0.16.2"])
end

