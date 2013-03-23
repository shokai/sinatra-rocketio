require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestRocketIO < MiniTest::Unit::TestCase

  def setup
    App.start
  end

  def teardown
    App.stop
  end

  def test_websocket_to_comet
    ## websocket --> server --> comet
    post_data = {:time => Time.now.to_s, :msg => 'hello!!', :to => nil}
    res = nil
    res2 = nil
    client = Sinatra::WebSocketIO::Client.new(App.websocketio_url).connect
    client.on :message do |data|
      res = data
    end

    client.on :connect do |session|
      client2 = Sinatra::CometIO::Client.new(App.cometio_url).connect
      client2.on :connect do |session2|
        post_data['to'] = session2
        client.push :message, post_data
      end
      client2.on :message do |data|
        res2 = data
        client2.close
        client.close
      end
    end

    50.times do
      break if res != nil
      sleep 0.1
    end
    client.close
    assert res2 != nil, 'server not respond'
    assert res2["time"] == post_data[:time]
    assert res2["msg"] == post_data[:msg]
    assert res == nil
  end

  def test_comet_to_websocket
    ## comet --> server --> websocket
    post_data = {:time => Time.now.to_s, :msg => 'hello!!', :to => nil}
    res = nil
    res2 = nil
    client = Sinatra::CometIO::Client.new(App.cometio_url).connect
    client.on :message do |data|
      res = data
    end

    client.on :connect do |session|
      client2 = Sinatra::WebSocketIO::Client.new(App.websocketio_url).connect
      client2.on :connect do |session2|
        post_data['to'] = session2
        client.push :message, post_data
      end
      client2.on :message do |data|
        res2 = data
        client2.close
        client.close
      end
      client2.on :disconnect do
        EM.stop_event_loop
      end
    end

    50.times do
      break if res != nil
      sleep 0.1
    end
    client.close
    assert res2 != nil, 'server not respond'
    assert res2["time"] == post_data[:time]
    assert res2["msg"] == post_data[:msg]
    assert res == nil
  end

end
