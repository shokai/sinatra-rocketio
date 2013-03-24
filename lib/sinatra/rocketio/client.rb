require File.expand_path '../../sinatra-rocketio/version', File.dirname(__FILE__)
require 'sinatra/cometio/client'
require 'sinatra/websocketio/client'
require 'httparty'
require 'json'
require 'event_emitter'

module Sinatra
  module RocketIO
    class Client
      class Error < StandardError
      end

      include EventEmitter
      attr_reader :settings, :type, :io

      def initialize(url, opt={:type => :websocket})
        @type = opt[:type].to_sym
        @io = nil
        @settings = JSON.parse HTTParty.get("#{url}/rocketio/settings").body
        @ws_close_timer = nil
        self
      end

      def connect
        this = self
        if @type == :websocket and @settings.include? 'websocket'
          @io = Sinatra::WebSocketIO::Client.new(@settings['websocket']).connect
        elsif type == :comet or @settings.include? 'comet'
          @io = Sinatra::CometIO::Client.new(@settings['comet']).connect
          @type = :comet
        else
          raise Error, "cannot find #{type} IO #{url}"
        end
        @io.on :* do |event_name, *args|
          this.emit event_name, *args
        end
        self
      end

      def close
        @io.close
      end

      def push(type, data)
        @io.push type, data
      end

      def method_missing(name, *args)
        @io.__send__ name, *args
      end

    end
  end
end
