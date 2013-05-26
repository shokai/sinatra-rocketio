require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestPushMultiClient < MiniTest::Test

  def test_push_multi
    ## client1(comet) --> server --> client2(comet) & client3(websocket)
    post_data = {:time => Time.now.to_s, :msg => 'hello!!', :to => nil}
    res = nil
    res2 = nil
    res3 = nil
    client = Sinatra::RocketIO::Client.new(App.url, :type => :comet).connect
    client.on :message do |data|
      res = data
    end

    client.on :connect do
      client2 = Sinatra::RocketIO::Client.new(App.url, :type => :comet).connect
      client2.on :connect do
        client3 = Sinatra::RocketIO::Client.new(App.url, :type => :websocket).connect
        client3.on :connect do
          post_data[:to] = [client2.session, client3.session]
          client.push :message, post_data
        end
        client3.on :message do |data|
          res3 = data
          client3.close
        end
      end
      client2.on :message do |data|
        res2 = data
        client2.close
      end
    end

    50.times do
      break if res2 != nil and res3 != nil
      sleep 0.1
    end
    client.close
    assert res2 != nil, 'server not respond'
    assert res2["time"] == post_data[:time]
    assert res2["msg"] == post_data[:msg]
    assert res3 != nil, 'server not respond'
    assert res3["time"] == post_data[:time]
    assert res3["msg"] == post_data[:msg]
    assert res == nil
  end

end
