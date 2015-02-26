require 'rails_helper'

describe Admin::SpotsHelper do
  describe "#status_label" do
    let(:spot) { create(:spot) }

    context "when pending" do
      it { expect(helper.status_label(spot)).to have_css('span.label-default') }
    end

    context "when approved" do
      before { spot.approved! }
      it { expect(helper.status_label(spot)).to have_css('span.label-success') }
    end

    context "when rejected" do
      before { spot.rejected! }
      it { expect(helper.status_label(spot)).to have_css('span.label-danger') }
    end
  end
end
