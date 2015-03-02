require 'rails_helper'

describe PhotoUploader do
  include CarrierWave::Test::Matchers

  it 'should trip metadata and fix exif orientation' do
    expect(subject).to receive(:strip)
    expect(subject).to receive(:fix_exif_rotation)
    subject.process!
  end

  context 'versions processing' do
    subject { described_class.new(double('mounted', id: 1)) }

    before { described_class.storage = :file }
    after  { described_class.storage = :fog }

    it 'creates large, small and thumb' do
      subject.store!(File.open('spec/fixtures/logo.png'))
      expect(subject.large).to be_no_larger_than(1000, 1000)
      expect(subject.small).to have_dimensions(100, 100)
      expect(subject.thumb).to have_dimensions(50, 50)
    end
  end
end
