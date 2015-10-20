FactoryGirl.define do

  factory :order_with_risky_payment, parent: :order_with_line_items do
    state "confirm"

    after :create do |order|
      FactoryGirl.create [:payment_with_risky_avs_code, :payment_with_risky_cvv_code].sample, order: order
    end
  end

  factory :payment_with_risky_avs_code , class: Spree::Payment do
    avs_response { Spree::Payment::RISKY_AVS_CODES.sample }
    state "completed"
    payment_method
    order
  end

  factory :payment_with_risky_cvv_code, class: Spree::Payment do
    cvv_response_code "A"
    state "completed"
    payment_method
    order
  end

  factory :payment_method, class: Spree::PaymentMethod do
    name { %w{ card cash check points}.sample }
  end

end
