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

desc "generate JavaScript lib for browser"
task :jslib do
  dest = "rocketio.js"
  dest_min = "rocketio.min.js"

  require "rubygems"
  require "sinatra/websocketio"
  require "sinatra/cometio"
  require "sinatra/rocketio"
  require "erb"

  websocketio_url = nil
  cometio_url = nil
  header = ERB.new(File.open(File.expand_path "HEADER.erb", File.dirname(__FILE__)).read).result(binding)
  js = ERB.new(Sinatra::RocketIO.javascript).result(binding)

  File.open(dest, "w+") do |f|
    f.puts header
    f.write js
  end
  puts " => #{dest}"
  File.open(dest_min, "w+") do |f|
    f.puts header
  end
  system "uglifyjs #{dest} >> #{dest_min}"
  puts " => #{dest_min}"
end
