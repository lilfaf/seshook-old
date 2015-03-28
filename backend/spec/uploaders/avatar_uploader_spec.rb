require 'rails_helper'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  subject { described_class.new(double('mounted', id: 1)) }

  context 'version processing' do
    before do
      described_class.storage = :file
      subject.store! File.open('spec/fixtures/logo.png')
    end

    after  { described_class.storage = :fog }

    it { expect(subject.thumb).to have_dimensions(50, 50) }
    it { expect(subject.medium).to have_dimensions(200, 200) }
  end
end
