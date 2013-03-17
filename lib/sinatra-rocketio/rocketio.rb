module Sinatra
  module RocketIO

    def self.push(type, data, opt={})
      Sinatra::CometIO.push type, data, opt
      Sinatra::WebSocketIO.push type, data, opt
    end

    def self.sessions
      {
        :websocket => Sinatra::WebSocketIO.sessions,
        :comet => Sinatra::CometIO.sessions
      }
    end

  end
end
EventEmitter.apply Sinatra::RocketIO
Sinatra::CometIO.on :* do |event_name, *args|
  Sinatra::RocketIO.emit event_name, [args, :comet].flatten
end
Sinatra::WebSocketIO.on :* do |event_name, *args|
  Sinatra::RocketIO.emit event_name, [args, :websocket].flatten
end
