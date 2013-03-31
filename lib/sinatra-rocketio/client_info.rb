require 'hashie'

module Sinatra
  module RocketIO
    class ClientInfo < Hashie::Mash
      def to_s
        "session=\"#{session}\" type=\"#{type}\" channel=\"#{channel}\""
      end
    end
  end
end
