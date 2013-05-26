module Sinatra
  module RocketIO

    def self.registered(app)
      app.register Sinatra::CometIO
      app.register Sinatra::WebSocketIO
      app.helpers  Sinatra::RocketIO::Helpers
      app.get '/rocketio/settings' do
        content_type 'application/json'
        response["Access-Control-Allow-Origin"] = "*"
        @setting_json ||= (
                           setting = {}
                           setting[:websocket] = websocketio_url if Sinatra::RocketIO.options[:websocket]
                           setting[:comet] = cometio_url if Sinatra::RocketIO.options[:comet]
                           setting.to_json
                           )
      end
      app.get '/rocketio/rocketio.js' do
        content_type 'application/javascript'
        @js ||= ERB.new(Sinatra::RocketIO.javascript).result(binding)
      end
      EM::defer do
        while !EM::reactor_running? do
          sleep 1
        end
        Sinatra::WebSocketIO.start if Sinatra::RocketIO.options[:websocket]
        Sinatra::RocketIO.emit :start
      end
    end

  end
end
