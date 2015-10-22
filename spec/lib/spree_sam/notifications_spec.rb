require "spec_helper"

describe SpreeSam::Notifications do

  describe ".build" do

    subject { SpreeSam::Notifications }

    SpreeSam::Notifications::PROVIDERS.each do |provider, class_name|
      it "creates an instance of configured notification provider" do
        SpreeSam::Preferences.notification_provider = provider
        expect(subject.build({})).to be_an_instance_of class_name
      end
    end

    context "default notification provider" do
      it "is parse" do
        expect(SpreeSam::Notifications::Providers::Parse).to receive :new
        subject.build({})
      end
    end
  end

end
