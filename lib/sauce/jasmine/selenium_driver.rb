require 'sauce'
require 'jasmine/selenium_driver'
module Sauce
  module Jasmine
    class SeleniumDriver < ::Jasmine::SeleniumDriver
      def initialize(os, browser, browser_version, domain)
        host = host[7..-1] if host =~ /^http:\/\//
          base_url = "http://#{domain}"
        @driver = Sauce::Selenium.new(:browser => browser,
                                      :os => os,
                                      :browser_version => browser_version,
                                      :browser_url => base_url,
                                      :job_name => "Jasmine")
      end

      def tests_have_finished?
        eval_js("jsApiReporter && jsApiReporter.finished")
      end

      def test_suites
        eval_js("var result = jsApiReporter.suites(); if (window.Prototype && Object.toJSON) { Object.toJSON(result) } else { JSON.stringify(result) }")
      end

      def test_results
        eval_js("var result = jsApiReporter.results(); if (window.Prototype && Object.toJSON) { Object.toJSON(result) } else { JSON.stringify(result) }")
      end

      def job_id
        @driver.session_id
      end
    end
  end
end
