require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'sinatra/base'
if development?
  $stdout.sync = true
  require 'sinatra/reloader'
  $:.unshift File.expand_path '../lib', File.dirname(__FILE__)
end
require 'sinatra/rocketio'
require File.dirname(__FILE__)+'/main'

set :haml, :escape_html => true
set :websocketio, :port => 8080

case RUBY_PLATFORM
when /linux/i then EM.epoll
when /bsd/i then EM.kqueue
end
EM.set_descriptor_table_size 10000

run ChatApp
