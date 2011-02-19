require 'jasmine/config'
require 'sauce/jasmine/selenium_driver'

module Sauce
  module Jasmine
    class Config < ::Jasmine::Config
      def start
        start_jasmine_server
        @client = Sauce::Jasmine::SeleniumDriver.new(browser, jasmine_host, @jasmine_server_port)
        @client.connect
      end
    end
  end
end
