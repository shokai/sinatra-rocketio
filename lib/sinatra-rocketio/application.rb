module Sinatra
  module RocketIO

    def self.registered(app)
      app.helpers Sinatra::RocketIO::Helpers
      EM::defer do
        while !EM::reactor_running? do
          sleep 1
        end
        if options[:comet]
          require 'sinatra/cometio'
          app.register Sinatra::CometIO
        end
        if options[:websocket]
          require 'sinatra/websocketio'
          app.register Sinatra::WebSocketIO
        end
        app.get '/rocketio/rocketio.js' do
          content_type 'application/javascript'
          @js ||= ERB.new(Sinatra::RocketIO.javascript).result(binding)
        end
        Sinatra::RocketIO.emit :regist_events
      end
    end

  end
end
