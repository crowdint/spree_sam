FactoryGirl.define do

  factory :payment_with_risky_avs_code , class: Spree::Payment do
    avs_response { Spree::Payment::RISKY_AVS_CODES.sample }
    payment_method
    order
  end

  factory :payment_with_risky_cvv_code, class: Spree::Payment do
    cvv_response_code "A"
    payment_method
    order
  end

  factory :payment_with_failed_state, class: Spree::Payment do
    state "failed"
    payment_method
    order
  end

  factory :payment_method, class: Spree::PaymentMethod do
    name { %w{ card cash check points}.sample }
  end

end
