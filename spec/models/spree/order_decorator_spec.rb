require "spec_helper"

describe Spree::Order do

  describe "state_machine" do

    context "when complete" do

      context "and is risky" do

        subject { FactoryGirl.create :order_with_risky_payment }

        before do
          allow(subject).to receive(:process_payments!).and_return true
        end

        it "triggers a risk notification" do
          expect(subject).to receive :send_risk_notification
          subject.next
        end
      end

      context "and is not risky" do

        subject { FactoryGirl.create :order_with_line_items }

        before do
          allow(subject).to receive(:process_payments!).and_return true
        end

        it "does not triggers a risk notification" do
          expect(subject).to_not receive :send_risk_notification
        end
      end
    end
  end

  describe "#send_risk_notification" do

    let(:notification) { double(:notification) }

    subject { FactoryGirl.build :order_with_risky_payment }

    before do
      allow(notification).to receive :push
    end

    it "builds and pushes a risk notification with order id" do
      expect(SpreeSam::Notifications).to receive(:build)
        .with(hash_including(
                title: "Risky Order",
                body: {
                  order_id: subject.id,
                  details: {
                    reason: "payment rejected",
                    date: instance_of(Time)
                  }
                },
                channels: instance_of(Array)
              ),
             )
        .and_return(notification)

      subject.send :send_risk_notification
    end

    context "when notifications channels for risky orders are configured" do

      before do
        SpreeSam::Preferences.configure do |config|
          config.notification_channels = {
            orders: {
              risky: %w{ test }
            }
          }
        end
      end

      it "uses defined channels when building the notification" do
        expect(SpreeSam::Notifications).to receive(:build)
          .with(hash_including(:title, :body, channels: ["test"]))
          .and_return notification
          subject.send :send_risk_notification
      end

      after do
        SpreeSam::Preferences.configure do |config|
          config.notification_channels = {
            orders: {
              risky: []
            }
          }
        end
      end
    end

  end

end
