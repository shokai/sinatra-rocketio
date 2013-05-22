WebSocket/Comet Chat
====================

* Ruby 1.8.7 or 1.9.2 or 1.9.3 or 2.0.0
* sinatra-rocketio with Sinatra1.3+


Install Dependencies
--------------------

    % gem install bundler
    % bundle install


Run
---

    % export PORT=5000
    % export WS_PORT=8080
    % rackup config.ru -p 5000

=> http://localhost:5000


Ruby Client
-----------

    % ruby bin/cui_chat_client.rb
    % ruby bin/cui_chat_client.rb http://localhost:5000 websocket
    % ruby bin/cui_chat_client.rb http://localhost:5000 comet
