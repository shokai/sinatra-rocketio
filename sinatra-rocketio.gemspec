lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra-rocketio/version'

Gem::Specification.new do |gem|
  gem.name          = "sinatra-rocketio"
  gem.version       = Sinatra::RocketIO::VERSION
  gem.authors       = ["Sho Hashimoto"]
  gem.email         = ["hashimoto@shokai.org"]
  gem.description   = %q{Node.js like I/O plugin for Sinatra}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/shokai/sinatra-rocketio"

  gem.files         = `git ls-files`.split($/).reject{|i| i=="Gemfile.lock" }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "rack"
  gem.add_dependency "sinatra"
  gem.add_dependency "eventmachine"
  gem.add_dependency "sinatra-contrib"
  gem.add_dependency "sinatra-cometio"
  gem.add_dependency "sinatra-websocketio"
end
