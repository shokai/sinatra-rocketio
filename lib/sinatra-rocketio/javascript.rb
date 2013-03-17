module Sinatra
  module RocketIO

    def self.javascript(*js_file_names)
      js_file_names = ['rocketio.js', 'cometio.js', 'websocketio.js', 'event_emitter.js']
      js = ''
      js_file_names.each do |i|
        js += case i
              when 'cometio.js'
                options[:comet] ? Sinatra::CometIO.javascript('cometio.js') : ''
              when 'websocketio.js'
                options[:websocket] ? Sinatra::WebSocketIO.javascript('websocketio.js') : ''
              else
                j = ''
                File.open(File.expand_path "../js/#{i}", File.dirname(__FILE__)) do |f|
                  j = f.read
                end
                j
              end + "\n"
      end
      js
    end

  end
end
