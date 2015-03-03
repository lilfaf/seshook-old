require 'rails_helper'

describe 'dashboard' do
  context 'not signed in' do
    it 'cannot visit dashboard and redirects to login' do
      visit admin_dashboard_path
      expect(page.current_path).to eq(new_admin_session_path)
      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end

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
    let(:admin) { create(:admin) }

    before { login_as admin }

    it 'can visit dashboard' do
      visit admin_dashboard_path
      expect(page.current_path).to eq(admin_dashboard_path)
      expect(page).to have_content('SESHOOK ADMIN')
      expect(page).not_to have_content('OAuth Applications')
      expect(page).not_to have_content('Jobs Monitoring')
      within '#wrapper' do
        expect(page).to have_content('Usage statistics')
      end
    end

    it 'can change graph period', js: true do
      visit admin_dashboard_path
      select('1 year', visible: false)
      expect(page).to have_content('1 year')
    end

    it 'can view latest user' do
      user = create(:user)
      visit admin_dashboard_path
      expect(page).to have_content('Latest users')
      expect(page).to have_css('.table.table-striped')
      expect(page).to have_content(user.email)
    end

    it 'can view latest pending spots' do
      spot = create(:spot)
      visit admin_dashboard_path
      expect(page).to have_content('Latest pending spots')
      expect(page).to have_css('.table.table-striped')
      expect(page).to have_content(spot.address.city)
    end

    it 'cannot visit sidekiq jobs path' do
      expect{ visit sidekiq_web_path }.to raise_error
    end
  end

  context 'signed in as superuser' do
    before { login_as create(:superadmin) }

    it 'should have superuser menus' do
      visit admin_dashboard_path
      expect(page).to have_content('OAuth Applications')
      expect(page).to have_content('Jobs Monitoring')
    end

    it 'can visit sidekiq monitring in new tab', js: true do
      visit admin_dashboard_path
      click_link 'Jobs Monitoring'
      expect(page.driver.browser.window_handles.size).to eq(2)
    end
  end
end
