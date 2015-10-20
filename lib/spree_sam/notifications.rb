require "spree_sam/notifications/providers/parse"

module SpreeSam
  module Notifications

    PROVIDERS = {
      "parse" => SpreeSam::Notifications::Providers::Parse
    }

    def self.build(payload)
      PROVIDERS[SpreeSam::Preferences.notification_provider].new payload
    end

  end
end
