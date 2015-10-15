require "httparty"

module SpreeSam
  module Notifications
    module Providers
      class Parse

        include HTTParty

        base_uri "https://api.parse.com"

        headers "X-Parse-Application-Id" => ENV["PARSE_APP_ID"],
                "X-Parse-REST-API-Key"   => ENV["PARSE_API_KEY"],
                "Content-Type"           => "application/json"


        def initialize(payload)
          @payload = payload.to_json
        end

        def push
          self.class.post "/1/push", body: @payload
        end

      end
    end
  end
end
