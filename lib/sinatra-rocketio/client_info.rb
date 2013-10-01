require 'hashie'

module Sinatra
  module RocketIO
    class ClientInfo < Hashie::Mash
      def to_s
        %Q{address="#{address}" session="#{session}" type="#{type}" channel="#{channel}"}
      end
    end
  end
end
