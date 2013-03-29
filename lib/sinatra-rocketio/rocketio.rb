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
        }.keys.each do |session|
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
      if args.size > 1
        Sinatra::RocketIO.emit event_name, args[0], {:session => args[1], :channel => Sinatra::RocketIO.channels[args[1]]}, :comet
      else
        Sinatra::RocketIO.emit event_name, {:session => args[0], :channel => Sinatra::RocketIO.channels[args[0]]}, :comet
      end
    end
  end
  if options[:websocket]
    Sinatra::WebSocketIO.on :* do |event_name, *args|
      if args.size > 1
        Sinatra::RocketIO.emit event_name, args[0], {:session => args[1], :channel => Sinatra::RocketIO.channels[args[1]]}, :websocket
      else
        Sinatra::RocketIO.emit event_name, {:session => args[0], :channel => Sinatra::RocketIO.channels[args[0]]}, :websocket
      end
    end
  end
end
