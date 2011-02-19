require 'sauce'
require 'jasmine/selenium_driver'
module Sauce
  module Jasmine
    class SeleniumDriver < ::Jasmine::SeleniumDriver
      def initialize(browser, host, port)
        host = host[7..-1] if host =~ /^http:\/\//
        @host = host
        @port = port
        @tunnel_domain = "#{rand(10000)}.jasmine.test"
        @driver = Sauce::Selenium.new(:browser => browser,
                                      :browser_url => "http://#{@tunnel_domain}",
                                      :job_name => "Jasmine",
                                      :'record-video' => false,
                                      :'record-screenshots' => false)
      end

      def connect
        puts "Setting up Sauce Connect..."
        @connection = Sauce::Connect.new(:domain => @tunnel_domain,
                                         :host => @host,
                                         :port => @port,
                                         :quiet => true)
        @connection.wait_until_ready
        puts "Sauce Connect ready."
        super
      end

      def disconnect
        @driver.stop
        @connection.disconnect if @connection
      end
    end
  end
end
