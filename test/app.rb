class App

  def self.running
    @running ? true : false
  end

  def self.port
    ENV['PORT'] || 5000
  end

  def self.ws_port
    ENV['WS_PORT'] || 9000
  end

  def self.url
    "http://localhost:#{port}"
  end

  def self.websocketio_url
    "ws://localhost:#{ws_port}"
  end

  def self.cometio_url
    "http://localhost:#{port}/cometio/io"
  end

  def self.app_dir
    File.expand_path 'app', File.dirname(__FILE__)
  end

  def self.start
    return if running
    @running = true
    cmd = "cd #{app_dir} && WS_PORT=#{ws_port} rackup config.ru -p #{port}"
    system cmd
  end

end
