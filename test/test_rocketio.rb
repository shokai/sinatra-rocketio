require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestRocketIO < MiniTest::Test

  def test_websocket_to_comet
    ## websocket --> server --> comet
    post_data = {:time => Time.now.to_s, :msg => 'hello!!', :to => nil}
    res = nil
    res2 = nil
    client = Sinatra::RocketIO::Client.new(App.url, :type => :websocket).connect
    client.on :message do |data|
      res = data
    end

    client.on :connect do
      client2 = Sinatra::RocketIO::Client.new(App.url, :type => :comet).connect
      client2.on :connect do
        post_data['to'] = client2.session
        client.push :message, post_data
      end
      client2.on :message do |data|
        res2 = data
        client2.close
        client.close
      end
    end

    50.times do
      break if res2 != nil
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
    client = Sinatra::RocketIO::Client.new(App.url, :type => :comet).connect
    client.on :message do |data|
      res = data
    end

    client.on :connect do
      client2 = Sinatra::RocketIO::Client.new(App.url, :type => :websocket).connect
      client2.on :connect do
        post_data['to'] = client2.session
        client.push :message, post_data
      end
      client2.on :message do |data|
        res2 = data
        client2.close
        client.close
      end
    end

    50.times do
      break if res2 != nil
      sleep 0.1
    end
    client.close
    assert res2 != nil, 'server not respond'
    assert res2["time"] == post_data[:time]
    assert res2["msg"] == post_data[:msg]
    assert res == nil
  end

end
