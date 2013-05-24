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
      attr_reader :settings, :type, :io, :channel

      public
      def initialize(url, opt={:type => :websocket, :channel => nil})
        @url = url
        @type = opt[:type].to_sym
        @channel = opt[:channel] ? opt[:channel].to_s : nil
        @io = nil
        @settings = nil
        @ws_close_thread = nil
        on :__connect do
          io.push :__channel_id, channel
          emit :connect
        end
        self
      end

      private
      def get_settings
        url = "#{@url}/rocketio/settings"
        begin
          res = HTTParty.get url
          unless res.code == 200
            emit :error, "#{res.code} get error (#{url})"
            sleep 10
            get_settings
          else
            @settings = JSON.parse res.body
          end
        rescue => e
          emit :error, "#{e} (#{url})"
          sleep 10
          get_settings
        end
      end

      public
      def connect
        get_settings unless @settings
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
          event_name = :__connect if event_name == :connect
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
        @io.close if @io
      end

      def push(type, data)
        @io.push type, data if @io
      end

      def wait(&block)
        loop do
          sleep 1
          yield if block_given?
        end
      end

      def method_missing(name, *args)
        @io.__send__ name, *args
      end

    end
  end
end
