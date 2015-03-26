require 'rails_helper'

describe 'authentication' do
  it 'cannot recover password' do
    visit new_admin_session_path
    expect(page).not_to have_content('Forgot your password?')
  end

  context 'with invalid email or password' do
    it 'fails and redirect to admin login' do
      login_for('invalid@email.com', 'seshook')
      expect(page.current_path).to eq(new_admin_session_path)
      expect(page).to have_content('Invalid email or password')
    end
  end

  context 'with valid email and password' do
    let(:admin) { create(:admin) }

    before { login_for admin.email, 'seshook123' }

    it 'signs in add redirect to admin dahboard' do
      expect(page.current_path).to eq(admin_dashboard_path)
      expect(page).to have_content('Signed in successfully')
    end

    it 'signs out and redirect to root' do
      click_link 'Log out'
      expect(page.current_path).to eq(root_path)
      expect(page).to have_content('Signed out successfully')
    end
  end

  context 'as a superuser' do
    let(:superadmin) { create(:superadmin) }

    it 'redirects to dashboard' do
      login_for superadmin.email, 'seshook123'
      expect(page.current_path).to eq(admin_dashboard_path)
    end
  end
end
