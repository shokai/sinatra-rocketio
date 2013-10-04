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
        }.each{|session, channel|
          push type, data, :to => session
        }
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
      session_id = args.size > 1 ? args[1] : args[0]
      address = sessions.include?(session_id) ? sessions[session_id][:remote_addr] : nil
      info = Sinatra::RocketIO::ClientInfo.new(:session => session_id, :address => address, :channel => Sinatra::RocketIO.channels[session_id], :type => :comet)
      if args.size > 1
        Sinatra::RocketIO.emit event_name, args[0], info
      else
        Sinatra::RocketIO.emit event_name, info
      end
    end
  end
  if options[:websocket]
    Sinatra::WebSocketIO.on :* do |event_name, *args|
      event_name = :__connect if event_name == :connect
      session_id = args.size > 1 ? args[1] : args[0]
      address = sessions.include?(session_id) ? sessions[session_id][:remote_addr] : nil
      info = Sinatra::RocketIO::ClientInfo.new(:session => session_id, :address => address, :channel => Sinatra::RocketIO.channels[session_id], :type => :websocket)
      if args.size > 1
        Sinatra::RocketIO.emit event_name, args[0], info
      else
        Sinatra::RocketIO.emit event_name, info
      end
    end
  end
end
