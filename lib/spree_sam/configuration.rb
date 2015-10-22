module SpreeSam
  class Configuration < Spree::Preferences::Configuration

    preference :notification_channels, :hash, default: {
      orders: {
        risky: []
      }
    }

    preference :notification_provider, :string, default: "parse"

  end
end
