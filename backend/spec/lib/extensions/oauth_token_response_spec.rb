require 'rails_helper'

describe Doorkeeper::OAuth::TokenResponse do
  let(:user) { create(:user) }
  let(:token) { Doorkeeper::AccessToken.create(resource_owner_id: user.id) }

  subject { described_class.new(token) }

  it { expect(subject.body).to have_key(:access_token) }
  it { expect(subject.body).to have_key(:user_id) }
  it { expect(subject.body[:user_id]).to eq(user.id) }
end
