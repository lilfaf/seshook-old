require 'rails_helper'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  subject { described_class.new(double('mounted', id: 1)) }

  context 'version processing' do
    before { described_class.storage = :file }
    after  { described_class.storage = :fog }

    it 'should create thumb version' do
      subject.store! File.open('spec/fixtures/logo.png')
      expect(subject.thumb).to have_dimensions(50, 50)
    end
  end
end
