require 'rails_helper'

describe User do
  subject { create(:user) }

  ## DB schema ----------------------------------------------------------------

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
  it { is_expected.to have_db_column(:role).with_options(null: false, default: 0) }
  it { is_expected.to have_db_column(:avatar) }
  it { is_expected.to have_db_column(:facebook_id) }
  it { is_expected.to have_db_column(:birthday) }
  it { is_expected.to have_db_column(:first_name) }
  it { is_expected.to have_db_column(:last_name) }
  it { is_expected.to have_db_column(:username).with_options(null: false) }
  it { is_expected.to have_db_column(:locale) }
  it { is_expected.to have_db_column(:verified) }
  it { is_expected.to have_db_column(:gender).with_options(null: false, default: 0) }

  it { is_expected.to have_db_index(:email).unique }
  it { is_expected.to have_db_index(:reset_password_token).unique }
  it { is_expected.to have_db_index(:facebook_id).unique }

  ## Validations --------------------------------------------------------------

  it { is_expected.to validate_presence_of(:role) }

  describe 'facebook user' do
    subject { create(:facebook_user) }
    it { is_expected.to validate_uniqueness_of(:facebook_id) }
    it { is_expected.to allow_value('', nil).for(:facebook_id) }
  end

  it 'allow male/femal as gender' do
    expect{subject.gender = 'male'}.not_to raise_error
    expect{subject.gender = 'female'}.not_to raise_error
    expect{subject.gender = 'dummy'}.to raise_error(ArgumentError)
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

  ## Associations -------------------------------------------------------------

  it { is_expected.to have_many(:spots) }
  it { is_expected.to have_many(:photos) }
  it { is_expected.to have_many(:albums) }
  it { is_expected.to have_one(:avatar_upload) }

  ## Concerns -----------------------------------------------------------------

  it_behaves_like 'temporal scopes'
  it_behaves_like 'ransack searchable'

  ## Callbacks ----------------------------------------------------------------

  describe 'processgin avatar' do
    include ActiveJob::TestHelper
    subject { build(:user) }
    let(:upload) { create(:avatar_upload) }

    after { clear_enqueued_jobs }

    it 'should enqueue jobs' do
      subject.new_avatar_upload_uuid = upload.uuid
      subject.save
      expect(enqueued_jobs.size).to eq(1)
    end
  end

  ## Instance methods ---------------------------------------------------------

  describe '#full_name' do
    subject { create(:user, first_name: 'John', last_name: 'Doe') }

    it 'concat first_name and last_name' do
      expect(subject.full_name).to eq('John Doe')
      subject.first_name = nil
      expect(subject.full_name).to eq('Doe')
    end
  end
end
