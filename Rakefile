require 'rubygems'
require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :build do
  system "gem build jasmine-sauce.gemspec"
end

task :push => :build do
  system "gem push `ls *.gem | sort | tail -n 1`"
end
