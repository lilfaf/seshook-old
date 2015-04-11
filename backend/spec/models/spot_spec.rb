require 'rails_helper'

describe Spot do
  subject { create(:spot) }

  it_behaves_like 'temporal scopes'
  it_behaves_like 'photoable'
  it_behaves_like 'ransack searchable'

  it { is_expected.to have_db_column(:name) }
  it { is_expected.to have_db_column(:status).with_options(null: false, default: 0) }
  it { is_expected.to have_db_column(:lonlat).with_options(null: false, geographic: true) }
  it { is_expected.to have_db_column(:user_id) }

  it { is_expected.to have_db_index(:status) }
  it { is_expected.to have_db_index(:lonlat) }
  it { is_expected.to have_db_index(:user_id) }

  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }
  it { is_expected.to validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }
  it { is_expected.to validate_uniqueness_of(:lonlat) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:address).dependent(:destroy) }
  it { is_expected.to have_many(:photos).dependent(:destroy) }
  it { is_expected.to have_many(:albums).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:address) }

  it 'has pending status by default' do
    expect(subject.pending?).to be(true)
  end

  it 'set latitude and longitude on initialize' do
    obj = described_class.find(subject.id)
    expect(obj.latitude).to eq(subject.lonlat.y)
    expect(obj.longitude).to eq(subject.lonlat.x)
  end

  it 'updates latlon before validations' do
    subject.latitude = 1.0
    expect(subject).to receive(:update_lonlat)
    subject.validate
  end

  describe 'search class methods' do
    let!(:far)     { create(:spot, latitude: 40,     longitude: -77) }
    let!(:close)   { create(:spot, latitude: 39.01,  longitude: -75.99) }
    let!(:closest) { create(:spot, latitude: 39.001, longitude: -75.999) }

    describe '.close_to' do
      it { expect(described_class.close_to(39, -76)).to eq([close, closest]) }
    end

    describe '.closest' do
      it { expect(described_class.closest(39, -76)).to eq(closest) }
    end
  end
end
