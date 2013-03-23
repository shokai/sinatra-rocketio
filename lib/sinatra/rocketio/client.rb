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
        @settings = JSON.parse HTTParty.get("#{url}/rocketio/settings").body
        type = opt[:type].to_sym

        if type == :websocket and @settings['websocket']
          @type = :websocket
          @io = Sinatra::WebSocketIO::Client.new @settings['websocket']
        elsif type == :comet and @settings['comet']
          @type = :comet
          @io = Sinatra::CometIO::Client.new @settings['comet']
        else
          raise Error, "cannot find #{type} IO #{url}"
        end
        this = self
        if @io
          @io.on :* do |event_name, *args|
            this.emit event_name, *args
          end
        end
        self
      end

      def connect
        @io.connect
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
