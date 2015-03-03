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

  describe "#options_for_graph_period_select" do
    let(:output) {
'<option value="3">3 days</option>
<option value="7">1 week</option>
<option selected="selected" value="30">1 month</option>
<option value="180">6 months</option>
<option value="365">1 year</option>'
    }

    it "returns expected options list" do
      expect(helper.options_for_graph_period_select).to eq(output)
    end
  end
end
