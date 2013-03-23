lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra-rocketio/version'

Gem::Specification.new do |gem|
  gem.name          = "sinatra-rocketio"
  gem.version       = Sinatra::RocketIO::VERSION
  gem.authors       = ["Sho Hashimoto"]
  gem.email         = ["hashimoto@shokai.org"]
  gem.description   = %q{WebSocket/Comet IO plugin for Sinatra}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/shokai/sinatra-rocketio"

  gem.files         = `git ls-files`.split($/).reject{|i| i=="Gemfile.lock" }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "thin"
  gem.add_development_dependency "haml"
  gem.add_development_dependency "sass"

  gem.add_dependency "sinatra-cometio", ">= 0.3.9"
  gem.add_dependency "sinatra-websocketio", ">= 0.1.7"
  gem.add_dependency "sinatra"
  gem.add_dependency "eventmachine", ">= 1.0.0"
  gem.add_dependency "event_emitter", ">= 0.2.4"
end
