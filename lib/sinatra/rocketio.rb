require 'eventmachine'
require 'event_emitter'
require 'hashie'
require 'sinatra/cometio'
require 'sinatra/websocketio_nostart'
require File.expand_path '../sinatra-rocketio/version', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/client_info', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/helpers', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/options', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/rocketio', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/javascript', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/application', File.dirname(__FILE__)
require File.expand_path '../sinatra-rocketio/channel', File.dirname(__FILE__)

module Sinatra
  module RocketIO
  end
  register RocketIO
end
