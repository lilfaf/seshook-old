require 'rails_helper'

describe Album do
  it { is_expected.to have_db_column(:name).with_options(null: false) }
  it { is_expected.to have_db_column(:description) }
  it { is_expected.to have_db_column(:albumable_id) }
  it { is_expected.to have_db_column(:albumable_type) }

  it { is_expected.to have_db_index([:albumable_type, :albumable_id]) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:albumable_id) }

  it { is_expected.to belong_to(:albumable) }
end
