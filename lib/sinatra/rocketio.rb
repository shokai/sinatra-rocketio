require 'eventmachine'
require 'sinatra/cometio'
require 'sinatra/websocketio'
require File.expand_path '../sinatra-rocketio/version', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/helpers', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/options', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/rocketio', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/javascript', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/application', File.dirname(__FILE__)

module Sinatra
  module RocketIO
  end
  register RocketIO
end
