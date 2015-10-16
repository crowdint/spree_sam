require "spree_sam/notifications/providers/base"

module SpreeSam
  module Notifications
    module Providers
      class Parse < Base

        base_uri "https://api.parse.com"

        headers "X-Parse-Application-Id" => ENV["PARSE_APP_ID"],
                "X-Parse-REST-API-Key"   => ENV["PARSE_API_KEY"],
                "Content-Type"           => "application/json"

        def initialize(message, data = {}, options = {})
          super
          @options[:channels] ||= []
        end


        def push
          build_payload!
          self.class.post "/1/push", body: payload.to_json
        end

        private

        def channels
          @options[:channels].map do |channel|
            SpreeSam::Preferences.notifications_parse_channels[channel]
          end.compact
        end

        def build_payload!
          @payload = {
            channels: channels,
            data: {
              alert: @message,
              info: @raw,
            },
            badge: @options[:badge] || "Increment",# Counter for pending notifications
            sound: @options[:sound] || "default"
          }
        end

      end
    end
  end
end
