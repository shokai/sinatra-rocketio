sinatra-rocketio
================

* Node.js like I/O plugin for Sinatra.
* Automatically selects from Comet and WebSocket.
* https://github.com/shokai/sinatra-rocketio
* [Wiki](https://github.com/shokai/sinatra-rocketio/wiki)
* [Handle 10K+ clients on 1 process](https://github.com/shokai/sinatra-websocketio/wiki/C10K)


Installation
------------

    % gem install sinatra-rocketio


Requirements
------------
* Ruby 1.8.7 or 1.9.2 or 1.9.3 or 2.0.0
* Sinatra 1.3.0+
* [EventMachine](http://rubyeventmachine.com)
* [jQuery](http://jquery.com)


Usage
-----
### Server --(WebSocket/Comet)--> Client

Server Side

```ruby
require 'sinatra'
require 'sinatra/rocketio'
set :cometio, :timeout => 120, :post_interval => 2, :allow_crossdomain => false
set :websocketio, :port => 5001
set :rocketio, :websocket => true, :comet => true # enable WebSocket and Comet

run Sinatra::Application
```
```ruby
io = Sinatra::RocketIO

io.on :connect do |client|
  puts "new client available - <#{client.session}> type:#{client.type} from:#{client.address}"
  io.push :temperature, 35  # to all clients
  io.push :light, {:value => 150}, {:to => client.session} # to specific client
end
```

Client Side

```html
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>
<script src="<%= rocketio_js %>"></script>
```
```javascript
var io = new RocketIO().connect();

io.on("temperature", function(value){
  console.log("server temperature : " + value);
}); // => "server temperature : 35"
io.on("light", function(data){
  console.log("server light sensor : " + data.value);
}); // => "server light sensor : 150"
```


### Client --(WebSocket/Ajax)--> Server

Client Side

```javascript
io.on("connect", function(){
  io.push("chat", {name: "shokai", message: "hello"}); // client -> server
});
```

Server Side

```ruby
io.on :chat do |data, client|
  puts "#{data['name']} : #{data['message']}  <#{client.session}> type:#{client.type} address:#{client.address}"
end
## => "shokai : hello  <12abcde345f6g7h8ijk> type:websocket"
```

### On "connect" Event

Client Side

```javascript
io.on("connect", function(){
  alert("connect!! "+io.session);
});
```

Server Side

```ruby
io.on :connect do |client|
  puts "new client <#{client.session}> type:#{client.type} address:#{client.address}"
  io.push :hello, "hello new client!!"
end

io.on :disconnect do |client|
  puts "client disconnected <#{client.session}> type:#{client.type}"
end
```

### On "error" Event

Client Side

```javascript
io.on("error", function(err){
  console.error(err);
});
```

### Remove Event Listener

Server Side

```ruby
event_id = io.on :chat do |data, client|
  puts "chat #{data} - from:#{client.session} type:#{client.type}"
end
io.removeListener event_id
```

or

```ruby
io.removeListener :chat  # remove all "chat" listener
```


Client Side

```javascript
var event_id = io.on("error", function(err){
  console.error("RocketIO error : "err);
});
io.removeListener(event_id);
```

or

```javascript
io.removeListener("error");  // remove all "error" listener
```


### Chanel

make client groups.

Client Side
```javascript
var io = new RocketIO({channel: "ch1"}).connect();  // set channel "ch1"

io.on("connect", function(){
  io.push("hi", "haaaaaaaai!!");
});

io.on("announce", function(msg){
  alert(msg);
  // => alert "new client a1b2cde345fg in ch1"
});
```

Server Side
```ruby
io = Sinatra::RocketIO

io.on :connect do |client|
  msg = "new client #{client.session} in #{client.channel}"
  io.push :announce, msg, :channel => client.channel  # to all clients in Channel "ch1"
end

io.on :hi do |msg, client|
  puts "client says #{msg} (channel:#{client.channel})"
  # => "client says haaaaaaaai!! (channel:ch1)"
end
```


### Config with ENV[]

configure with ENV variables.

    % export WS_PORT=9000
    % export WEBSOCKET=disable
    % export COMET=enable
    % bundle exec rackup config.ru  #=> start sinatra app

disable comet and enable websocket on port 9000.


Sample Apps
-----------
- https://github.com/shokai/sinatra-rocketio/wiki/Sample-Apps


JavaScript Lib for browser
--------------------------

### Download

- [rocketio.js](https://raw.github.com/shokai/sinatra-rocketio/master/rocketio.js)
- [rocketio.min.js](https://raw.github.com/shokai/sinatra-rocketio/master/rocketio.min.js)


### Usage

```html
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>
<script src="/rocketio.min.js"></script>
```
```javascript
var io = new RocketIO().connect("http://example.com");

io.on("connect", function(){
  alert(io.type + " connect!! " + io.session);
});
```

### Generate JS Lib

    % npm install -g uglify-js
    % gem install bundler
    % bundle install
    % rake jslib

=> rocketio.js and rocketio.min.js



Test
----

    % gem install bundler
    % bundle install

start server

    % rake test_server

run test

    % rake test


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
