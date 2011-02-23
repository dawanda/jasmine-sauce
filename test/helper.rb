require 'rubygems'
require 'test/unit'
require 'fileutils'
require 'tmpdir'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

def ensure_rvm_installed
  rvm_executable = File.expand_path("~/.rvm/bin/rvm")
  if File.exist? rvm_executable
    unless defined?(RVM)
      rvm_lib_path = File.expand_path("~/.rvm/lib")
      $LOAD_PATH.unshift(rvm_lib_path) unless $LOAD_PATH.include?(rvm_lib_path)
      require 'rvm'
    end
  else
    raise "You do not have RVM installed. It is required for the integration tests.\n" +
      "Please install it from http://rvm.beginrescueend.com/"
  end
end

def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen(RUBY_PLATFORM =~ /mswin/ ? 'NUL:' : '/dev/null')
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
end

