require 'rails_helper'

describe ApplicationHelper do
  describe "#bootstrap_class_for" do
    it { expect(helper.bootstrap_class_for('success')).to eq('alert-success') }
    it { expect(helper.bootstrap_class_for('error')).to eq('alert-danger') }
    it { expect(helper.bootstrap_class_for('alert')).to eq('alert-warning') }
    it { expect(helper.bootstrap_class_for('notice')).to eq('alert-info') }
  end

  describe "nav_link" do
    it "returns an active nav link" do
      helper.params[:controller] = 'admin/spots'
      expect(helper.nav_link('Spots', admin_spots_path)).to have_css('li.active')
      expect(helper.nav_link('Users', admin_users_path)).not_to have_css('li.active')
    end
  end

  describe "delete_action" do
    let(:resource) { create(:user) }

    it "has tooltip and glyph trash icon" do
      expect(helper.delete_action(resource)).to have_css('a[data-toggle="tooltip"]')
      expect(helper.delete_action(resource)).to have_css('.glyphicon.glyphicon-trash')
    end
  end
end
