require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestSettingsIO < MiniTest::Test

  def test_settings
    res = JSON.parse HTTParty.get("#{App.url}/rocketio/settings").body
    assert App.websocketio_url == res['websocket']
    assert App.cometio_url == res['comet']
  end

end
