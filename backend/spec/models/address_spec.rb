require 'rails_helper'

describe Address do
  subject { create(:address) }

  ## DB schema ----------------------------------------------------------------

  it { is_expected.to have_db_column(:country_code).with_options(null: false) }
  it { is_expected.to have_db_column(:street).with_options(null: false) }
  it { is_expected.to have_db_column(:city).with_options(null: false) }
  it { is_expected.to have_db_column(:zip) }
  it { is_expected.to have_db_column(:state) }
  it { is_expected.to have_db_column(:addressable_id) }
  it { is_expected.to have_db_column(:addressable_type) }

  it { is_expected.to have_db_index([:addressable_type, :addressable_id]) }
  it { is_expected.to have_db_index([:street, :city]) }

  ## Validations --------------------------------------------------------------

  it { is_expected.to validate_uniqueness_of(:street).scoped_to(:city) }
  it { is_expected.to validate_presence_of(:street) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:country_code) }

  ## Associations -------------------------------------------------------------

  it {is_expected.to belong_to(:addressable).touch(true) }

  describe '#country_name' do
    it 'returns the country name' do
      subject.country_code = 'fr'
      expect(subject.country_name).to eq('France')
    end
  end
end
