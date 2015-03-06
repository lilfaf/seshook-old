require 'rails_helper'

describe Admin::DashboardController do
  before { sign_in current_admin }

  describe "GET #index" do
    before { get :index }

    it { expect(response).to render_with_layout(:admin) }
    it { expect(response).to render_template(:index) }
  end
end
