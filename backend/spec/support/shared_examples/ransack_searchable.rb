require 'rails_helper'

shared_examples_for 'ransack searchable' do
  let!(:class_name)  { described_class.name.downcase.to_sym }
  let!(:recent)      { create(class_name) }
  let!(:latest)      { create(class_name) }

  it { expect(described_class.respond_to?(:search_with_sort)).to be(true) }

  it 'order defauts to desc' do
    records = described_class.search_with_sort(nil).result
    expect(records.first).to eq(latest)
    expect(records.last).to eq(recent)
  end
end