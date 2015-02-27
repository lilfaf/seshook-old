require 'rails_helper'

describe Upload do
  it { is_expected.to have_db_column(:uuid).with_options(length: 16) }
  it { is_expected.to have_db_column(:filename) }
  it { is_expected.to have_db_column(:content_type) }
  it { is_expected.to have_db_column(:state) }
  it { is_expected.to have_db_column(:upload_type) }
  it { is_expected.to have_db_column(:user_id) }
  it { is_expected.to have_db_column(:uploadable_id) }
  it { is_expected.to have_db_column(:uploadable_type) }
  it { is_expected.to have_db_column(:pending_at) }
  it { is_expected.to have_db_column(:imported_at) }
end
