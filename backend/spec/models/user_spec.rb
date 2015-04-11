require 'rails_helper'

describe User do
  subject { create(:user) }

  it_behaves_like 'temporal scopes'

  it { is_expected.to have_db_column(:email).with_options(null: false, default: '') }
  it { is_expected.to have_db_column(:encrypted_password).with_options(null: false, default: '') }
  it { is_expected.to have_db_column(:reset_password_token) }
  it { is_expected.to have_db_column(:reset_password_sent_at) }
  it { is_expected.to have_db_column(:remember_created_at) }
  it { is_expected.to have_db_column(:sign_in_count).with_options(null: false, default: 0) }
  it { is_expected.to have_db_column(:current_sign_in_at) }
  it { is_expected.to have_db_column(:last_sign_in_at) }
  it { is_expected.to have_db_column(:current_sign_in_ip) }
  it { is_expected.to have_db_column(:last_sign_in_ip) }
  it { is_expected.to have_db_column(:role) }
  it { is_expected.to have_db_column(:avatar) }
  it { is_expected.to have_db_column(:facebook_id) }
  it { is_expected.to have_db_column(:birthday) }
  it { is_expected.to have_db_column(:first_name) }
  it { is_expected.to have_db_column(:last_name) }
  it { is_expected.to have_db_column(:username).with_options(null: false) }
  it { is_expected.to have_db_column(:locale) }
  it { is_expected.to have_db_column(:verified) }

  it { is_expected.to have_db_index(:email).unique }
  it { is_expected.to have_db_index(:reset_password_token).unique }

  it { is_expected.to validate_presence_of(:role) }

  it { is_expected.to have_many(:spots) }
  it { is_expected.to have_many(:photos) }
  it { is_expected.to have_many(:albums) }
  it { is_expected.to have_one(:avatar_upload) }

  it 'has member role by default' do
    expect(subject.member?).to be(true)
  end

  let(:valid_emails) {[
    'valid@email.com',
    'valid@email.com.uk',
    'e@email.com',
    'valid+email@email.com',
    'valid-email@email.com',
    'valid_email@email.com',
    'valid.email@email.com'
  ]}
  let(:invalid_emails) {[
    'invalid email@email.com',
    '.invalid.email@email.com',
    'invalid.email.@email.com',
    '@email.com',
    '.@email.com',
    'invalidemailemail.com',
    '@invalid.email@email.com',
    'invalid@email@email.com',
    'invalid.email@@email.com'
  ]}

  it 'validates valid email addresses' do
    valid_emails.each do |email|
      subject.email = email
      expect(subject.valid?).to be(true)
    end
  end

  it 'validates invalid email addresses' do
    invalid_emails.each do |email|
      subject.email = email
      expect(subject.valid?).to be(false)
    end
  end

  describe 'processgin avatar' do
    include ActiveJob::TestHelper
    subject { build(:user) }
    let(:upload) { create(:avatar_upload) }

    after   { clear_enqueued_jobs }

    it 'should enqueue jobs' do
      subject.new_avatar_upload_uuid = upload.uuid
      subject.save
      expect(enqueued_jobs.size).to eq(1)
    end
  end

  describe '#full_name' do
    subject {
      create(:user, first_name: 'John', last_name: 'Doe')
    }

    it 'concat first_name and last_name' do
      expect(subject.full_name).to eq('John Doe')
      subject.first_name = nil
      expect(subject.full_name).to eq('Doe')
    end
  end
end
