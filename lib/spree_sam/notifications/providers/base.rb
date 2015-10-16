require "httparty"

module SpreeSam
  module Notifications
    module Providers
      class Base

        attr_reader :payload

        include HTTParty

        def initialize(message, raw = {}, options = {})
          @message = message
          @raw = raw
          @options = options
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
