require "spree_sam/notifications/providers/parse"

module SpreeSam
  module Notifications

    PROVIDERS = {
      parse: SpreeSam::Notifications::Providers::Parse
    }

    def self.build(provider, payload)
      PROVIDERS[provider].new payload
    end

  end
end
