require 'rspec'
require 'rspec/core/rake_task'

namespace :jasmine do
  namespace :ci do
    desc 'Run Jasmine tests in the cloud'
    RSpec::Core::RakeTask.new(:sauce) do |t|
      t.rspec_opts = ["--colour", "--format", "progress"]
      t.verbose = true
      t.pattern = ['spec/javascripts/support/jasmine_sauce_runner.rb']
    end
  end
end
