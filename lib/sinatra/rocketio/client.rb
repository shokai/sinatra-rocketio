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
        @ws_close_thread = nil
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
        if @type == :websocket
          @ws_close_thread = Thread.new do
            sleep 3
            Thread.new do
              close
            end
            emit :error, "websocket port is not open"
            @type = :comet
            connect
          end
          once :connect do
            Thread.kill @ws_close_thread if @ws_close_thread
            @ws_close_thread = nil
          end
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
