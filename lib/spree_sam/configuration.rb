module SpreeSam
  class Configuration < Spree::Preferences::Configuration
    preference :notifications_parse_channels, :hash, default: {}
  end
end
