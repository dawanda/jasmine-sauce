module Sauce
  module Jasmine
    class Runner
      def initialize
        @config = Config.new
        @server = Server.new(@config)
      end

      def run
        setup
        begin
          run_tests
        ensure
          teardown
        end
      end

      def setup
        @server.start
        puts "Setting up Sauce Connect..."
        @tunnel = Sauce::Connect.new(:domain => @config.tunnel_domain,
                                         :host => @server.host,
                                         :port => @server.port,
                                         :quiet => @config.quiet_tunnel?)
        @tunnel.wait_until_ready
        puts "Sauce Connect ready"
      end
      
      def run_tests
        puts "running tests..."
        browsers = Sauce::Config.new.browsers
        results = {}

        threads = browsers.map do |browser_spec|
          browser_string = browser_spec.join('/')
          Thread.new do
            begin
              result, job_id = run_tests_in_browser(*browser_spec)
              puts "Suite finished on #{browser_string}"
              Thread.exclusive do
                results[browser_string] = result, job_id
              end
            rescue => e
              results[browser_string] = e
            end
          end
        end
        threads.each(&:join)

        results.each do |browser_string, result|
          if result.respond_to? :[]
            actual_result, job_id = result
            success = actual_result && actual_result.values.all? {|suite_result| suite_result['result'] == "passed"}
            if !success
              puts "[FAILURE] Failure on #{browser_string}. See https://saucelabs.com/jobs/#{job_id} for details."
              at_exit { exit!(1) }
            end
          else
            raise result
          end
        end
      end

      def teardown
        puts "Shutting down Sauce Connect..."
        @tunnel.disconnect
        puts "Sauce Connect shut down"
      end

      def run_tests_in_browser(os, browser, browser_version)
        driver = SeleniumDriver.new(os, browser, browser_version, @config.tunnel_domain)
        driver.connect
        job_id = driver.job_id
        begin
          while !driver.tests_have_finished?
            sleep 1.0
          end
          result = driver.test_results
        ensure
          driver.disconnect
          return result, job_id
        end
      end
    end
  end
end

