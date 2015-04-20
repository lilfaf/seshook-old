require 'rails_helper'

describe FacebookAvatarJob do
  include ActiveJob::TestHelper
  include FacebookHelper

  let(:user) { create(:user, fb_access_token: fb_user['access_token']) }

  before { subject.perform(user) }
  after  { clear_performed_jobs }

  it { expect(user.avatar.url).to match(/amazonaws.com/) }
end
