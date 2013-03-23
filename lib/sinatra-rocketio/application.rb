module Sinatra
  module RocketIO

    def self.registered(app)
      app.helpers Sinatra::RocketIO::Helpers
      EM::defer do
        while !EM::reactor_running? do
          sleep 1
        end
        if options[:comet]
          app.register Sinatra::CometIO
        end
        if options[:websocket]
          app.register Sinatra::WebSocketIO
          Sinatra::WebSocketIO.start
        end
        app.get '/rocketio/rocketio.js' do
          content_type 'application/javascript'
          @js ||= ERB.new(Sinatra::RocketIO.javascript).result(binding)
        end
        app.get '/rocketio/settings' do
          content_type 'application/json'
          @setting_json ||= (
                             setting = {}
                             setting[:websocket] = websocketio_url if Sinatra::RocketIO.options[:websocket]
                             setting[:comet] = cometio_url if Sinatra::RocketIO.options[:comet]
                             setting.to_json
                             )
        end
        app.routes["GET"].delete_if{|route|
          "/cometio/cometio.js" =~ route[0] or "/websocketio/websocketio.js" =~ route[0]
        }
        Sinatra::RocketIO.emit :start
      end
    end

  end
end
