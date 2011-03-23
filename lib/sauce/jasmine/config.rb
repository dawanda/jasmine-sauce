require 'jasmine/config'
require 'sauce/jasmine/selenium_driver'

module Sauce
  module Jasmine
    class Config < ::Jasmine::Config
      attr_accessor :sauce_connect, :os, :browser, :browser_version
      attr_writer :base_url

      def initialize
        sauce_connect = true
      end

      def start
        start_jasmine_server if sauce_connect
        @client = Sauce::Jasmine::SeleniumDriver.new(browser, os, browser_version, jasmine_host,
                                                     @jasmine_server_port, sauce_connect, @base_url)
        @client.connect
      end
    end
  end
end
