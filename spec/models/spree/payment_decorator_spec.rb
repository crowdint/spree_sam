require "spec_helper"

describe Spree::Payment do

  describe "callbacks" do
    context "after_save" do
      context "when an order is risky" do

        context "with risky avs response code" do
          subject { FactoryGirl.build :payment_with_risky_avs_code }

          it "triggers send_risk_notification" do
            expect(subject).to receive :send_risk_notification
            subject.save
          end
        end

        context "with risky cvv response code" do
          subject { FactoryGirl.build :payment_with_risky_cvv_code }

          it "triggers send_risk_notification" do
            expect(subject).to receive :send_risk_notification
            subject.save
          end
        end

        context "with a failed state" do
          subject { FactoryGirl.build :payment_with_failed_state }

          it "triggers send_risk_notification" do
            expect(subject).to receive :send_risk_notification
            subject.save
          end
        end

      end
    end
  end

  describe "#is_risky?" do

    context "when cvv is risky" do
      before do
        allow(subject).to receive(:is_cvv_risky?) { true }
      end

      it "returns true" do
        expect(subject.is_risky?).to be(true)
      end
    end

    context "when avs is risky" do
      before do
        allow(subject).to receive(:is_avs_risky?) { true }
      end

      it "returns true" do
        expect(subject.is_risky?).to be(true)
      end
    end

    context "when state is failed" do
      before do
        allow(subject).to receive(:state) { "failed" }
      end

      it "returns true" do
        expect(subject.is_risky?).to be(true)
      end
    end

  end

  describe "send_risk_notification" do
    let(:notification) { double(:notification) }

    subject { FactoryGirl.build :payment_with_risky_avs_code }

    it "builds and pushes a payment rejected notification with parse provider and order id" do
      expect(SpreeSam::Notifications).to receive(:build)
        .with(:parse, "Risky Order",  hash_including(
        order_id: subject.order.id,
        details: {
          reason: "payment rejected",
          date: instance_of(Time)
        }
        ))
        .and_return(notification)

      expect(notification).to receive(:push) {}
      subject.send :send_risk_notification
    end
  end

end
