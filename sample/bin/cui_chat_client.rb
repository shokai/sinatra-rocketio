#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
$:.unshift File.expand_path '../../lib', File.dirname(__FILE__)
require 'sinatra/rocketio/client'

name = `whoami`.strip || 'shokai'
url = ARGV.shift || 'http://localhost:5000'
type = ARGV.shift || :websocket

io = Sinatra::RocketIO::Client.new(url, :type => type, :channel => "1").connect
#io = Sinatra::RocketIO::Client.new('http://localhost:5000', :type => :comet).connect

io.on :connect do
  puts "#{io.type} connect!! (session_id:#{io.session})"
end

io.on :chat do |data|
  puts "<#{data['name']}> #{data['message']}"
end

io.on :error do |err|
  STDERR.puts err
end

io.on :disconnect do
  puts "disconnected!!"
end

loop do
  line = STDIN.gets.strip
  next if line.empty?
  io.push :chat, {:message => line, :name => name}
end
