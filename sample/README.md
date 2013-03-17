WebSocket/Comet Chat
====================

* Ruby 1.8.7 or 1.9.2 or 1.9.3 or 2.0.0
* sinatra-rocketio with Sinatra1.3+


Install Dependencies
--------------------

    % gem install bundler foreman
    % bundle install


Run
---

    % foreman start

=> http://localhost:5000


Deploy Heroku
-------------

    % mkdir ~/rocketio-sample
    % cp -R ./ ~/rocketio-sample/
    % cd ~/rocketio-sample
    % git init
    % git add ./
    % git commit -m "first sample chat"
    % heroku create --stack cedar
    % git push heroku master
    % heroku open
