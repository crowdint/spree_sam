Spree::Payment.class_eval do

  after_save :send_risk_notification, if: :is_risky?

  def is_risky?
    is_cvv_risky? || is_avs_risky? || state == "failed"
  end

  private

  def send_risk_notification
    SpreeSam::Notifications.build(:parse,
                                  "Risky Order",
                                  order_id: order.id,
                                  details: {
                                    reason: "payment rejected",
                                    date: Time.now
                                  }
                                 ).push
  end

end
