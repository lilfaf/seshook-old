require 'rails_helper'

describe ProcessAvatarJob do
  include ActiveJob::TestHelper

  let(:user)   { create(:user) }
  let(:upload) { create(:upload) }

  before do
    allow(upload).to receive(:private_url).and_return('http://placehold.it/100x100')
    subject.perform(user, upload)
  end

  after  { clear_performed_jobs }

  it { expect(user.avatar.url).to match(/100x100.gif/) }
  it { expect(upload.state).to match('imported') }
end
