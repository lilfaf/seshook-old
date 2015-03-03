require 'rails_helper'

describe AdminChart do
  subject { described_class.new(30) }

  let!(:spot) { create(:spot) }
  let!(:user) { create(:user) }

  describe '.stats_for' do
    it { expect(subject.stats_for([Spot, User])).to be_a(Array) }
    it { expect(subject.stats_for([Spot, User]).size).to be(2) }
  end

  describe '.stats_for_model' do
    let!(:old)   { create(:user, created_at: 3.days.ago) }
    let!(:older) { create(:user, created_at: 2.month.ago) }

    context 'days period unit' do
      it { expect(subject.stats_for_model(User)[:data].size).to eq(4) }
      it { expect(subject.stats_for_model(User)[:data].values[3]).to eq(1) }
      it { expect(subject.stats_for_model(User)[:data].values[1]).to eq(0) }
    end

    context 'month period unit' do
      subject { described_class.new(90) }

      it { expect(subject.stats_for_model(User)[:data].size).to eq(3) }
      it { expect(subject.stats_for_model(User)[:data].values[0]).to eq(1) }
      it { expect(subject.stats_for_model(User)[:data].values[2]).to eq(1) }
    end
  end
end
