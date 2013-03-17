pid_file = ENV['PID_FILE'] || "/tmp/sinatra-rocketio-test-pid"
EM::defer do
  while !EM::reactor_running? do
    sleep 0.1
  end
  File.open(pid_file, "w+") do |f|
    f.write Process.pid.to_s
  end
end

class TestApp < Sinatra::Base
  register Sinatra::RocketIO
  io = Sinatra::RocketIO

  get '/' do
    "sinatra-rocketio v#{Sinatra::RocketIO::VERSION}"
  end

  io.on :connect do |session, type|
    puts "new client <session:#{session}> <type:#{type}>"
  end

  io.on :disconnect do |session, type|
    puts "disconnect client <session:#{session}> <type:#{type}>"
  end

  io.on :broadcast do |data, from, type|
    puts from
    puts "broadcast <session:#{from}> <type:#{type}> - #{data.to_json}"
    push :broadcast, data
  end

  io.on :message do |data, from, type|
    puts "message <session:#{from}> <type:#{type}> - #{data.to_json}"
    push :message, data, :to => data['to']
  end

end
