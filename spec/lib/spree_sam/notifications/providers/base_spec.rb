require "spec_helper"

describe SpreeSam::Notifications::Providers::Base do

  describe ".new" do

    subject { SpreeSam::Notifications::Providers::Base }

    it "assigns title, body and channels to instance variables" do
      provider = subject.new title: "Something happened",
                             body: {
                               message: "useful"
                             },
                             options: {
                               sound: "default"
                             }

      expect(provider.instance_variable_get('@title')).to eq("Something happened")
      expect(provider.instance_variable_get('@body')).to eq({message: "useful"})
      expect(provider.instance_variable_get('@options')).to eq({sound: "default"})
    end

  end

end
