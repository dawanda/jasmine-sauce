require File.expand_path("../helper.rb", __FILE__)

class TestIntegrations < Test::Unit::TestCase
  @@globally_setup = false

  def setup
    if !@@globally_setup
      ensure_rvm_installed
      Dir.chdir File.expand_path("../..", __FILE__) do
        silence_stream(STDOUT) do
          system("gem build jasmine-sauce.gemspec")
        end
      end
      ENV['JASMINE_SAUCE_GEM'] = File.expand_path("../../"+Dir.entries(".").select {|f| f =~ /jasmine-sauce-.*.gem/}.sort.last, __FILE__)
      @@globally_setup = true
    end
  end

  def run_with_ruby(ruby_version, test)
    ruby_version = RVM.list_strings.find {|version| version =~ /#{ruby_version}/}
    if ruby_version.nil?
      RVM.install ruby_version
      ruby_version = RVM.list_strings.find {|version| version =~ /#{ruby_version}/}
    end

    gemset_name = "jasmine-sauce-gem_#{test.to_s}"
    rubie = RVM.environment(ruby_version)
    rubie.gemset.create gemset_name
    begin
      rubie = RVM.environment("#{ruby_version}@#{gemset_name}")
      send(test, rubie)
    ensure
      rubie.gemset.delete gemset_name
    end
  end

  def run_in_environment(env, command)
    result = env.run(command)
    assert result.successful?, result.stderr
  end

  def in_tempdir
    oldwd = Dir.pwd
    temp = File.join(Dir.tmpdir, "jasmine_sauce_gem_integration_test_#{rand(100000)}")
    Dir.mkdir(temp)
    Dir.chdir(temp)
    begin
      yield temp
    ensure
      Dir.chdir(oldwd)
      FileUtils.remove_dir(temp)
    end
  end

  def with_rails_3_environment(env)
    in_tempdir do |temp|
        run_in_environment(env, "gem install rails --no-rdoc --no-ri")
        run_in_environment(env, "rails new rails3_testapp")
        Dir.chdir("rails3_testapp")
        run_in_environment(env, "bundle install")
        run_in_environment(env, "rake db:migrate")
        yield
    end
  end

  def with_rails_2_environment(env)
    in_tempdir do |temp|
      run_in_environment(env, "gem install rails -v 2.3.11 --no-rdoc --no-ri")
      run_in_environment(env, "gem install sqlite3 --no-rdoc --no-ri")
      run_in_environment(env, "rails rails2_testapp")
      Dir.chdir("rails2_testapp")
      run_in_environment(env, "rake db:migrate")
      yield
    end
  end

#### NO RAILS 2 SUPPORT YET ####
#  def recipe_rails2(env)
#    with_rails_2_environment(env) do
#      run_in_environment(env, "gem install \"$JASMINE_SAUCE_GEM\" --no-rdoc --no-ri")
#      run_in_environment(env, "script/generate jasmine")
#      run_in_environment(env, "script/generate sauce:jasmine")
#      run_in_environment(env, "rake jasmine:ci:sauce")
#    end
#  end

  def recipe_rails3(env)
    with_rails_3_environment(env) do
      # Add some Sauce
      open("Gemfile", 'a') do |f|
        f.puts "gem 'jasmine-sauce'"
      end
      run_in_environment(env, "gem install \"$JASMINE_SAUCE_GEM\" --no-rdoc --no-ri")
      run_in_environment(env, "bundle install")
      run_in_environment(env, "bundle exec jasmine init")
      run_in_environment(env, "rails generate sauce:jasmine")
      run_in_environment(env, "rake jasmine:ci:sauce")
    end
  end

  # Turn the recipes into tests
  self.instance_methods(false).select {|m| m =~ /recipe_.*/ }.each do |recipe|
    define_method(("test_ruby18_"+recipe).to_sym) do
      run_with_ruby("ruby-1.8.7", recipe.to_sym)
    end
    define_method(("test_ruby19_"+recipe).to_sym) do
      run_with_ruby("ruby-1.9.2", recipe.to_sym)
    end
  end
end

