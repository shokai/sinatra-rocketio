class ChatApp < Sinatra::Base
  register Sinatra::RocketIO
  io = Sinatra::RocketIO

  io.once :start do
    puts "RocketIO start!!!"
  end

  io.on :connect do |client, type|
    puts "new client <#{client[:session]}> (type:#{type})"
    push :chat, {:name => "system", :message => "new #{type} client <#{client[:session]}>"}, :channel => client[:channel]
    push :chat, {:name => "system", :message => "welcome <#{client[:session]}>"}, :to => client[:session]
  end

  io.on :disconnect do |client, type|
    puts "disconnect client <#{client[:session]}> (type:#{type})"
    push :chat, {:name => "system", :message => "bye <#{client[:session]}>"}, :channel => client[:channel]
  end

  io.on :chat do |data, client, type|
    puts "#{data['name']} : #{data['message']}  (session:#{client[:session]} channel:#{client[:channel]} type:#{type})"
    push :chat, data, :channel => client[:channel]
  end

  io.on :error do |err|
    STDERR.puts "error!! #{err}"
  end

  get '/' do
    redirect '/chat/1'
  end

  get '/chat/:channel' do
    @channel = params[:channel]
    haml :chat
  end

  get '/:source.css' do
    scss params[:source].to_sym
  end
end
