require "spec_helper"

describe SpreeSam::Notifications::Providers::Parse do

  describe '.new' do
    subject { SpreeSam::Notifications::Providers::Parse }

    it "initializes channels when not provided in options" do
      client = subject.new("Important")
      expect(client.instance_variable_get("@options")[:channels]).to eq([])
    end

    it "uses channels from options hash when provided" do
      client = subject.new("Important", {}, {channels: ["store"]})
      expect(client.instance_variable_get("@options")[:channels]).to include("store")
    end
  end

  describe "#build_payload" do

    subject { SpreeSam::Notifications::Providers::Parse }

    before do
      @client = subject.new("Important", {something: "important" }, {sound: "chime"})
      @client.send :build_payload!
    end

    it "uses @message as notification alert message" do
      expect(@client.payload[:data][:alert]) .to eq("Important")
    end

    it "uses @raw as notification raw info" do
      expect(@client.payload[:data][:info]) .to eq({something: "important"})
    end

    it "uses the badge provided in options or fallbacks to 'Increment'" do
      expect(@client.payload[:badge]).to eq("Increment")
    end

    it "uses the badge provided in options or fallbacks to 'default'" do
      expect(@client.payload[:sound]).to eq("chime")
    end
  end

  describe "#channels" do

    subject { SpreeSam::Notifications::Providers::Parse }

    context "when channels have been configured" do

      before do
        SpreeSam::Preferences.notifications_parse_channels = {
          store: "foo",
          api: "bar"
        }
      end

      context "but channels are not specified on client initialization" do
        before do
          @client = subject.new("Important", {}, {})
        end

        it "returns an empty array" do
          expect(@client.send(:channels)).to eq([])
        end
      end

      context "and channels are specified on client initialization" do
        before do
          @client = subject.new("Important", {}, {channels: [:store, :api]})
        end

        it "returns the values of the given channels" do
          expect(@client.send(:channels)).to include("foo", "bar")
        end
      end
    end
  end

  describe "#push" do
    subject { SpreeSam::Notifications::Providers::Parse }

    let(:client) { subject.new("Important") }
    let(:payload) { client.send :build_payload! ; client.payload }


    it "triggers an http post request to parse API to create a push notification" do
      expect(subject).to receive(:post).with("/1/push", body: payload.to_json )
      client.push
    end
  end

  describe "#channels" do

  end

end
