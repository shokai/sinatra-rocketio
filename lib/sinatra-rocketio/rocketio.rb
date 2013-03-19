EventEmitter.apply Sinatra::RocketIO

module Sinatra
  module RocketIO

    def self.push(type, data, opt={})
      if options[:websocket]
        if !opt[:to] or Sinatra::WebSocketIO.sessions.include? opt[:to]
          Sinatra::WebSocketIO.push type, data, opt
        end
      end
      if options[:comet]
        if !opt[:to] or Sinatra::CometIO.sessions.include? opt[:to]
          Sinatra::CometIO.push type, data, opt
        end
      end
    end

    def self.sessions
      {
        :websocket => Sinatra::WebSocketIO.sessions,
        :comet => Sinatra::CometIO.sessions
      }
    end

  end
end

Sinatra::RocketIO.once :start do
  if options[:comet]
    Sinatra::CometIO.on :* do |event_name, *args|
      if args.size > 1
        Sinatra::RocketIO.emit event_name, args[0], args[1], :comet
      else
        Sinatra::RocketIO.emit event_name, args[0], :comet
      end
    end
  end
  if options[:websocket]
    Sinatra::WebSocketIO.on :* do |event_name, *args|
      if args.size > 1
        Sinatra::RocketIO.emit event_name, args[0], args[1], :websocket
      else
        Sinatra::RocketIO.emit event_name, args[0], :websocket
      end
    end
  end
end
