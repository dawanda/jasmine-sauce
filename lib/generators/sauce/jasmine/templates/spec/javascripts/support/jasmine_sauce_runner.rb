require 'rubygems'
require 'jasmine'
require 'sauce/jasmine'

jasmine_config_overrides = File.expand_path(File.join(File.dirname(__FILE__), 'jasmine_config.rb'))
require jasmine_config_overrides if File.exist?(jasmine_config_overrides)

$jasmine_config = Sauce::Jasmine::Config.new
$jasmine_config.sauce_connect = false

$tunnel_domain = "#{rand(10000)}.jasmine.test"

def start_server(port = 8888)
  handler = Rack::Handler.default
  handler.run Jasmine.app($jasmine_config), :Port => port, :AccessLog => []
end

def start_jasmine_server
  jasmine_server_port = Jasmine::find_unused_port
  Thread.new do
    start_server(jasmine_server_port)
  end
  Jasmine::wait_for_listener(jasmine_server_port, "jasmine server")
  puts "jasmine server started."
  return jasmine_server_port
end

port = start_jasmine_server


puts "Setting up Sauce Connect..."
@connection = Sauce::Connect.new(:domain => $tunnel_domain,
                                 :host => "127.0.0.1",
                                 :port => port,
                                 :quiet => true)
@connection.wait_until_ready
puts "Sauce Connect ready!"

builders = []

RSpec.configuration.after(:suite) do
  builders.each do |builder|
    builder.stop
  end
end

Sauce::Config.new.browsers.each do |os, browser, browser_version|
  config = Sauce::Jasmine::Config.new
  config.sauce_connect = false
  config.os = os
  config.browser = browser
  config.browser_version = browser_version

  config.base_url = "http://#{$tunnel_domain}"
  spec_builder = Jasmine::SpecBuilder.new(config)
  builders << spec_builder

  spec_builder.start
  spec_builder.declare_suites
end

at_exit do
  puts "\nShutting down Sauce Connect..."
end
