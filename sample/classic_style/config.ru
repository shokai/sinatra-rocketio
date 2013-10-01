require 'rubygems'
$:.unshift File.expand_path '../../lib', File.dirname(__FILE__)
require 'sinatra'
if development?
  $stdout.sync = true
  require 'sinatra/reloader'
end
require 'sinatra/rocketio'
require 'haml'
require 'sass'
require File.dirname(__FILE__)+'/main'

set :haml, :escape_html => true
set :cometio, :timeout => 120, :post_interval => 2, :allow_crossdomain => true
set :websocketio, :port => (ENV['WS_PORT'] || 9000).to_i
set :rocketio, :comet => true, :websocket => true

case RUBY_PLATFORM
when /linux/i then EM.epoll
when /bsd/i then EM.kqueue
end
EM.set_descriptor_table_size 10000

run Sinatra::Application
