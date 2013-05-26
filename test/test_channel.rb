require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestChannel < MiniTest::Test

  def test_channel
    ## client1(comet, channel "aaa") --> server --> client3(websocket, channel "aaa")
    ## client2(websocket, channel "bbb") not receive data from channel "aaa"
    post_data = {:time => Time.now.to_s, :msg => 'hello!!'}
    res = nil
    res2 = nil
    res3 = nil
    client = Sinatra::RocketIO::Client.new(App.url, :type => :comet, :channel => "aaa").connect
    client.on :to_channel do |data|
      res = data
    end

    client.on :connect do
      client2 = Sinatra::RocketIO::Client.new(App.url, :type => :websocket, :channel => "bbb").connect
      client2.on :connect do
        client3 = Sinatra::RocketIO::Client.new(App.url, :type => :websocket, :channel => "aaa").connect
        client3.on :connect do
          client.push :to_channel, post_data
        end
        client3.on :to_channel do |data|
          res3 = data
          client3.close
        end
      end
      client2.on :to_channel do |data|
        res2 = data
        client2.close
      end
    end

    50.times do
      break if res != nil and res3 != nil
      sleep 0.1
    end
    client.close
    assert res != nil, 'comet server not respond'
    assert res["time"] == post_data[:time]
    assert res["msg"] == post_data[:msg]
    assert res3 != nil, 'websocket server not respond'
    assert res3["time"] == post_data[:time]
    assert res3["msg"] == post_data[:msg]
    assert res2 == nil, 'channel error'
  end

end
