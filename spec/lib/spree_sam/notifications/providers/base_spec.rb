require "spec_helper"

describe SpreeSam::Notifications::Providers::Base do

  describe ".new" do

    subject { SpreeSam::Notifications::Providers::Base }

    it "assigns message, raw data and options to instance variables" do
      provider = subject.new "Something happened",
                             {something: "useful"},
                             {sound: "default"}

      expect(provider.instance_variable_get('@message')).to eq("Something happened")
      expect(provider.instance_variable_get('@raw')).to eq({something: "useful"})
      expect(provider.instance_variable_get('@options')).to eq({sound: "default"})
    end

  end

end
