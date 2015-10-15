require "spec_helper"

describe SpreeSam::Notifications do

  describe ".build" do

    subject { SpreeSam::Notifications }

    it "creates an instance of given notification provider" do
      SpreeSam::Notifications::PROVIDERS.each do |provider, class_name|
        expect(subject.build(provider, {})).to be_an_instance_of class_name
      end
    end
  end

end
