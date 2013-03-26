require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = "test/test_*.rb"
end

desc "Start test server"
task :test_server do
  require File.expand_path 'test/app', File.dirname(__FILE__)
  App.start
end

task :default => :test
