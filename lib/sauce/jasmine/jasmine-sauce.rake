require 'sauce/jasmine'

namespace :jasmine do
  namespace :ci do
    desc 'Run Jasmine tests in the cloud'
    task :sauce do
      runner = Sauce::Jasmine::Runner.new
      runner.run
    end
  end
end
