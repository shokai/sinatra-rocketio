require 'rubygems'
require 'bundler/setup'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'minitest/autorun'
require 'sinatra/rocketio/client'
require 'httparty'
require 'json'
require File.expand_path 'app', File.dirname(__FILE__)
