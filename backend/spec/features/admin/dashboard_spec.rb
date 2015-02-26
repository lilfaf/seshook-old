require 'rails_helper'

describe 'dashboard' do
  context 'as a user' do
    let(:user) { create(:user) }

    it 'denie access and redirect to root' do
      login_as user
      visit admin_dashboard_path
      expect(page.current_path).to eq(root_path)
      expect(page).to have_content('Unauthorized access!')
    end
  end

  context 'as an admin' do
    # TODO add tests
  end
end
