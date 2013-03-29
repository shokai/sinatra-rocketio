module Sinatra
  module RocketIO

    def self.channels
      @@channels ||= {}
    end

  end
end

Sinatra::RocketIO.on :__channel_id do |channel, client|
  Sinatra::RocketIO.channels[client[:session]] = channel
end

