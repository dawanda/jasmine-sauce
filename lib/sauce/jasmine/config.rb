require 'jasmine/config'
require 'sauce/jasmine/selenium_driver'

module Sauce
  module Jasmine
    class Config < ::Jasmine::Config
      attr_accessor :tunnel_domain

      def initialize
        sauce_connect = true
        @tunnel_domain = "#{rand(10000)}.jasmine.test"
      end

      def quiet_tunnel?
        false
      end
    end
  end
end
