module Sinatra
  module RocketIO
    module Helpers

      def rocketio_js
        "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}/rocketio/rocketio.js"
      end

    end
  end
end
