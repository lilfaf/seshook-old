require 'rails_helper'

describe Spot do
  subject { create(:spot) }

  it { is_expected.to have_db_column(:name) }
  it { is_expected.to have_db_column(:status).with_options(null: false, default: 0) }
  it { is_expected.to have_db_column(:lonlat).with_options(null: false, geographic: true) }
  it { is_expected.to have_db_column(:user_id) }

  it { is_expected.to have_db_index(:status) }
  it { is_expected.to have_db_index(:lonlat) }
  it { is_expected.to have_db_index(:user_id) }

  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }
  it { is_expected.to validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }
  it { is_expected.to validate_uniqueness_of(:lonlat) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:address).dependent(:destroy) }
  it { is_expected.to have_many(:photos).dependent(:destroy) }
  it { is_expected.to have_many(:albums).dependent(:destroy) }
end
