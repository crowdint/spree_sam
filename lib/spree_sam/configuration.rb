module SpreeSam
  class Configuration < Spree::Preferences::Configuration

    preference :notification_channels, :hash, default: {
      orders: {
        risky: []
      }
    }

  end
end
