require 'rails_helper'

describe Samples::Loader do
  subject { -> { described_class.perform } }

  it { is_expected.not_to raise_error }
  it { is_expected.to change{ Spot.count }.by(1) }
  it { is_expected.to change{ Address.count }.by(1) }
  it { is_expected.to change{ Photo.count }.by(1) }
end
