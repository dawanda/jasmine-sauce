require 'sauce'
require 'jasmine/selenium_driver'
module Sauce
  module Jasmine
    class SeleniumDriver < ::Jasmine::SeleniumDriver
      def initialize(browser, os, version, host, port, sauce_connect, base_url = nil)
        host = host[7..-1] if host =~ /^http:\/\//
        @host = host
        @port = port
        @sauce_connect = sauce_connect
        base_url ||= "#{rand(10000)}.jasmine.test"
        @driver = Sauce::Selenium.new(:browser => browser,
                                      :os => os,
                                      :browser_version => version,
                                      :browser_url => base_url,
                                      :job_name => "Jasmine",
                                      :'record-video' => true,
                                      :'record-screenshots' => true)
      end

      def connect
        if @sauce_connect
          puts "Setting up Sauce Connect..."
          @connection = Sauce::Connect.new(:domain => @tunnel_domain,
                                           :host => @host,
                                           :port => @port,
                                           :quiet => true)
          @connection.wait_until_ready
          puts "Sauce Connect ready."
        end
        super
      end

      def disconnect
        @driver.stop
        @connection.disconnect if @connection
      end
    end
  end
end
