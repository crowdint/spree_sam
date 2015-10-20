require "spec_helper"

describe SpreeSam::Notifications::Providers::Parse do

  describe "#build_payload" do

    subject { SpreeSam::Notifications::Providers::Parse }

    before do
      @client = subject.new(title: "Important", body: { something: "important" }, options: { sound: "chime" })
      @client.send :build_payload!
    end

    it "uses @message as notification alert message" do
      expect(@client.payload[:data][:alert]) .to eq("Important")
    end

    it "uses @raw as notification raw info" do
      expect(@client.payload[:data][:info]) .to eq({ something: "important" })
    end

    it "uses the badge provided in options or fallbacks to 'Increment'" do
      expect(@client.payload[:badge]).to eq("Increment")
    end

    it "uses the badge provided in options or fallbacks to 'default'" do
      expect(@client.payload[:sound]).to eq("chime")
    end
  end

  describe "#push" do
    subject { SpreeSam::Notifications::Providers::Parse }

    let(:client) { subject.new(title: "Important") }
    let(:payload) { client.send :build_payload! ; client.payload }


    it "triggers an http post request to parse API to create a push notification formatted as JSON" do
      expect(subject).to receive(:post).with("/1/push", body: payload.to_json )
      client.push
    end
  end

end
