class ChatApp < Sinatra::Base
  register Sinatra::RocketIO
  io = Sinatra::RocketIO

  io.once :start do
    puts "RocketIO start!!!"
  end

  io.on :connect do |session, type|
    puts "new client <#{session}> (type:#{type})"
    push :chat, {:name => "system", :message => "new #{type} client <#{session}>"}
    push :chat, {:name => "system", :message => "welcome <#{session}>"}, {:to => session}
  end

  io.on :disconnect do |session, type|
    puts "disconnect client <#{session}> (type:#{type})"
    push :chat, {:name => "system", :message => "bye <#{session}>"}
  end

  io.on :chat do |data, from, type|
    puts "#{data['name']} : #{data['message']}  (from:#{from} type:#{type})"
    push :chat, data
  end

  io.on :error do |err|
    STDERR.puts "error!! #{err}"
  end

  get '/' do
    haml :index
  end

  get '/:source.css' do
    scss params[:source].to_sym
  end
end
