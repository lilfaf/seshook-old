require 'rails_helper'

shared_examples_for 'temporal scopes' do
  let!(:klass)  { described_class.name.downcase.to_sym }
  let!(:recent) { create(klass) }
  let!(:latest) { create(klass) }
  let!(:old)    { create(klass, created_at: 1.days.ago) }
  let!(:older)  { create(klass, created_at: 1.month.ago) }
  let!(:oldest) { create(klass, created_at: 6.month.ago) }

  it 'returns records between dates' do
    expect(described_class.created_between(1.days.ago, Time.now)).to eq([recent, latest])
  end

  it 'returns records in period grouped by day' do
    expect(described_class.created_by_day(7.days.ago).count.size).to eq(2)
  end

  it 'returns records in period grouped by month' do
    expect(described_class.created_by_month(7.month.ago).count.size).to eq(7)
  end

  it 'returns recent spots' do
    expect(described_class.recent(2)).to eq([latest, recent])
  end
end
