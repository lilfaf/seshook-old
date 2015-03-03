require 'rails_helper'

describe 'authentication' do
  def login_for(email, password)
    visit new_admin_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
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

    it 'signs out and redirec to root' do
      click_link 'Log out'
      expect(page.current_path).to eq(root_path)
      expect(page).to have_content('Signed out successfully')
    end
  end
end

