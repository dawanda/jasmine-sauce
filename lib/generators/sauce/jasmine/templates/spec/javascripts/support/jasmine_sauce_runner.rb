require 'rubygems'
require 'jasmine'
require 'sauce/jasmine'

jasmine_config_overrides = File.expand_path(File.join(File.dirname(__FILE__), 'jasmine_config.rb'))
require jasmine_config_overrides if File.exist?(jasmine_config_overrides)

jasmine_config = Sauce::Jasmine::Config.new
spec_builder = Jasmine::SpecBuilder.new(jasmine_config)

should_stop = false

RSpec.configuration.after(:suite) do
  spec_builder.stop if should_stop
end

spec_builder.start
should_stop = true
spec_builder.declare_suites
