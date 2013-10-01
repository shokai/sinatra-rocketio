EventEmitter.apply Sinatra::RocketIO

module Sinatra
  module RocketIO

    def self.push(type, data, opt={})
      if opt.include? :to and opt[:to].kind_of? Array
        opt[:to].each do |to|
          push type, data, :to => to
        end
      elsif opt.include? :channel
        channels.select{|session, channel|
          channel == opt[:channel].to_s
        }.each do |session|
          push type, data, :to => session
        end
      else
        if options[:websocket]
          Sinatra::WebSocketIO.push type, data, opt
        end
        if options[:comet]
          Sinatra::CometIO.push type, data, opt
        end
      end
    end

    def self.sessions
      {
        :websocket => Sinatra::WebSocketIO.sessions.keys,
        :comet => Sinatra::CometIO.sessions.keys
      }
    end

  end
end

Sinatra::RocketIO.once :start do
  if options[:comet]
    Sinatra::CometIO.on :* do |event_name, *args|
      event_name = :__connect if event_name == :connect
      if args.size > 1
        Sinatra::RocketIO.emit event_name, args[0], Sinatra::RocketIO::ClientInfo.new(:session => args[1], :address => sessions[args[1]][:remote_addr], :channel => Sinatra::RocketIO.channels[args[1]], :type => :comet)
      else
        Sinatra::RocketIO.emit event_name, Sinatra::RocketIO::ClientInfo.new(:session => args[0], :address => sessions[args[0]][:remote_addr], :channel => Sinatra::RocketIO.channels[args[0]], :type => :comet)
      end
    end
  end
  if options[:websocket]
    Sinatra::WebSocketIO.on :* do |event_name, *args|
      event_name = :__connect if event_name == :connect
      if args.size > 1
        Sinatra::RocketIO.emit event_name, args[0], Sinatra::RocketIO::ClientInfo.new(:session => args[1], :address => sessions[args[1]][:remote_addr], :channel => Sinatra::RocketIO.channels[args[1]], :type => :websocket)
      else
        Sinatra::RocketIO.emit event_name, Sinatra::RocketIO::ClientInfo.new(:session => args[0], :address => sessions[args[0]][:remote_addr], :channel => Sinatra::RocketIO.channels[args[0]], :type => :websocket)
      end
    end
  end
end
