module Sinatra
  module RocketIO

    def self.registered(app)
      app.register Sinatra::CometIO
      app.register Sinatra::WebSocketIO
      app.helpers Sinatra::RocketIO::Helpers

      app.get '/rocketio/rocketio.js' do
        content_type 'application/javascript'
        @js ||= ERB.new(Sinatra::RocketIO.javascript).result(binding)
      end
    end

  end
end
