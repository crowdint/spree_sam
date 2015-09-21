module Spree
  module Api
    module SamApiHelpers

  SAM_ATTRIBUTES = [
      :promotion_attributes,
      :promotion_action_attributes,
      :promotion_rule_attributes
  ]

  mattr_reader *SAM_ATTRIBUTES

  @@promotion_attributes = [
      :id, :name, :type, :usage_limit, :code, :path, :expires_at, :starts_at,
      :description, :advertise, :match_policy
  ]

  @@promotion_action_attributes = [
      :id, :type, :position
  ]

  @@promotion_rule_attributes = [
      :id, :type, :code
  ]

  def calculator_attribute calculator
    mapping = {
        'FlatRate' => 'preferred_amount',
        'FlatPercentItemTotal' => 'preferred_flat_percent',
    }
    klass = calculator.type.demodulize
    {
        mapping[klass] => calculator.send(mapping[klass])
    }
  end

end