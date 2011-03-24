module Sauce
  module Jasmine
    class Server
      attr_reader :port, :host

      def initialize(config)
        @config = config
        @host = "127.0.0.1"
      end

      def start
        @port = ::Jasmine::find_unused_port
        Thread.new do
          handler = Rack::Handler.default
          handler.run ::Jasmine.app(@config), :Port => @port, :AccessLog => []
        end
        ::Jasmine::wait_for_listener(@port, "jasmine server")
      end

      def stop
        # nothing, yet
      end
    end
  end
end
