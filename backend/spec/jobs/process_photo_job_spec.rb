require 'rails_helper'

describe ProcessPhotoJob do
  include ActiveJob::TestHelper

  let(:spot)   { create(:spot) }
  let(:upload) { create(:upload) }

  before do
    allow(upload).to receive(:private_url).and_return('http://placehold.it/100x100')
    subject.perform(spot, upload)
  end

  after  { clear_performed_jobs }

  it { expect(spot.photos.size).to eq(1) }
  it { expect(upload.state).to eq('imported') }
end
