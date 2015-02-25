require 'rails_helper'

describe BaseImageUploader do
  subject { described_class.new(double('mounted', id: 1)) }

  it 'should upload to s3 bucket' do
    subject.store! File.open('spec/fixtures/logo.png')
    expect(subject.url).to match(/^https:\/\/seshook-test.s3-us-west-2.amazonaws.com\/*/)
  end

  it 'should allow images extensions' do
    expect(subject.extension_white_list).to eq(%w(jpg jpeg gif png))
  end
end

