require 'rails_helper'

describe Photo do
  it { is_expected.to have_db_column(:file).with_options(null: false) }
  it { is_expected.to have_db_column(:content_type).with_options(null: false) }
  it { is_expected.to have_db_column(:size).with_options(null: false) }
  it { is_expected.to have_db_column(:key) }
  it { is_expected.to have_db_column(:etag) }
  it { is_expected.to have_db_column(:photoable_id) }
  it { is_expected.to have_db_column(:photoable_type) }

  it { is_expected.to have_db_index([:photoable_type, :photoable_id]) }

  it { is_expected.to validate_presence_of(:file) }
  it { is_expected.to validate_presence_of(:content_type) }
  it { is_expected.to validate_presence_of(:size) }

  it { is_expected.to belong_to(:photoable) }
end