require 'rubygems'
require 'bundler/setup'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'minitest/autorun'
require 'em-cometio-client'
require 'em-websocketio-client'
require File.expand_path 'app', File.dirname(__FILE__)


['SIGHUP', 'SIGINT', 'SIGKILL', 'SIGTERM'].each do |sig|
  Kernel.trap sig do
    App.stop
  end
end
