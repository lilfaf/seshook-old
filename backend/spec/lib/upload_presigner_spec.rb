require 'rails_helper'

describe UploadPresigner do
  let(:uuid) { SecureRandom.uuid }

  before { described_class.any_instance.stub(:uuid).and_return(uuid) }

  describe '#initialize' do
    it 'expires default to 15 minutes' do
      expect(subject.expires).to eq(900)
    end

    it 'set custom expiration' do
      obj = described_class.new(expires: 1.minute)
      expect(obj.expires).to eq(60)
    end
  end

  describe '#data' do
    it 'has uuid and presignd url keys' do
      expect(subject.data[:uuid]).to eq(uuid)
      expect(subject.data[:url]).to match(/https:\/\/us-west-2.s3-us-west-2.amazonaws.com/)
    end
  end
end
