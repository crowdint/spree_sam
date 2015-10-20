require "httparty"

module SpreeSam
  module Notifications
    module Providers
      class Base

        attr_reader :payload

        include HTTParty

        def initialize(payload = {})
          @title    = payload[:title]
          @body     = payload[:body]
          @channels = payload[:channels] || []
          @options  = payload[:options]  || {}
        end

        # Implement in subclasses
        def build_payload!
        end

        # Implement in subclasses
        def push
        end

      end
    end
  end
end
