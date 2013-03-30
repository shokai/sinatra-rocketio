class TestApp < Sinatra::Base
  register Sinatra::RocketIO
  io = Sinatra::RocketIO

  get '/' do
    "sinatra-rocketio v#{Sinatra::RocketIO::VERSION}"
  end

  io.on :connect do |client|
    puts "new client <session:#{client.session}> <type:#{client.type}>"
  end

  io.on :disconnect do |client|
    puts "disconnect client <session:#{client.session}> <type:#{client.type}>"
  end

  io.on :broadcast do |data, client|
    puts from
    puts "broadcast <session:#{client.session}> <type:#{client.type}> - #{data.to_json}"
    push :broadcast, data
  end

  io.on :message do |data, client|
    puts "message <session:#{client.session}> <type:#{client.type}> - #{data.to_json}"
    push :message, data, :to => data['to']
  end

  io.on :to_channel do |data, client|
    puts "message to channel:#{client.channel} <type:#{client.type}> - #{data.to_json}"
    push :to_channel, data, :channel => client.channel
  end

end
