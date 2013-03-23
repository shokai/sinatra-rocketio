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
      attr_reader :settings, :type

      def initialize(url)
        @settings = JSON.parse HTTParty.get("#{url}/rocketio/settings").body
        if @settings['websocket']
          @type = :websocket
          @client = Sinatra::WebSocketIO::Client.new @settings['websocket']
        elsif @settings['comet']
          @type = :comet
          @client = Sinatra::CometIO::Client.new @settings['comet']
        else
          raise Error, "cannot find IO #{url}"
        end
        this = self
        if @client
          @client.on :* do |event_name, *args|
            if args.size > 1
              this.emit event_name, args[0], args[1]
            else
              this.emit event_name, args[0]
            end
          end
        end
        self
      end

      def connect
        @client.connect
        self
      end

      def close
        @client.close
      end

      def push(type, data)
        @client.push type, data
      end

      def method_missing(name, *args)
        @client.__send__ name, *args
      end

    end
  end
end
