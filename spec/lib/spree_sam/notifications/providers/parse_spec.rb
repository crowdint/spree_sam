require "spec_helper"

describe SpreeSam::Notifications::Providers::Parse do


  describe ".new" do
    subject { SpreeSam::Notifications::Providers::Parse }
    let(:payload) { { data: "test" } }

    it "creates a new instance initialized with given payload in JSON" do
      client = subject.new(payload)
      expect(client.instance_variable_get("@payload")).to eq(payload.to_json)
    end
  end

  describe "#push" do
    subject { SpreeSam::Notifications::Providers::Parse }

    let(:payload) { { data: "test" } }
    let(:client) { subject.new(payload) }

    it "creates an http post request to parse push notifications API  with given payload" do
      expect(subject).to receive(:post).with("/1/push", body: payload.to_json )
      client.push
    end

  end

end
