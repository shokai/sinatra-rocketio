module Sinatra
  module RocketIO

    def self.channels
      @@channels ||= {}
    end

  end
end

Sinatra::RocketIO.on :__channel_id do |channel, client|
  channels[client[:session]] = channel
  client.channel = channel
  emit :connect, client
end
Sinatra::RocketIO.on :disconnect do |client, type|
  channels.delete client[:session]
end
