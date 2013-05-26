require 'rubygems'
require 'sinatra'
require 'sinatra/base'
$stdout.sync = true
$:.unshift File.expand_path '../../lib', File.dirname(__FILE__)
require 'sinatra/rocketio'
require File.dirname(__FILE__)+'/main'

run TestApp
