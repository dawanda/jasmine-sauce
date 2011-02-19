require 'rails/generators'

module Sauce
  module Generators
    class JasmineGenerator < ::Rails::Generators::Base
      desc "Augment Jasmine to optionally use Sauce OnDemand"

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end
      
      def copy
        directory "spec"
        directory "lib"
      end
    end
  end
end
