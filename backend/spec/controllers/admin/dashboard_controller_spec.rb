require 'rails_helper'

describe Admin::DashboardController do
  let(:admin) { create(:admin) }
  before { sign_in admin }

  describe "GET #index" do
    before { get :index }

    it { expect(response).to render_with_layout(:admin) }
    it { expect(response).to render_template(:index) }
  end
end
