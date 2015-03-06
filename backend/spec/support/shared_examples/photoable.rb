require 'rails_helper'

shared_examples_for 'photoable' do
  include ActiveJob::TestHelper

  subject { build("#{described_class.name.downcase}_with_upload".to_sym) }
  after   { clear_enqueued_jobs }

  it { is_expected.to have_many(:photos).dependent(:destroy) }
  it { is_expected.to have_many(:photo_uploads) }

  it 'should enqueue jobs' do
    subject.save
    expect(enqueued_jobs.size).to eq(1)
  end
end