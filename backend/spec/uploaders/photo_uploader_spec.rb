require 'rails_helper'

describe PhotoUploader do
  it 'should trip metadata and fix exif orientation' do
    expect(subject).to receive(:strip)
    expect(subject).to receive(:fix_exif_rotation)
    subject.process!
  end
end
