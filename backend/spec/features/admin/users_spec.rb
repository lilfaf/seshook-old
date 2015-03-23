require 'rails_helper'

describe 'managing users' do
  let!(:user)  { create(:user) }
  let!(:admin) { create(:admin) }

  context 'not signed in as admin' do
    it 'cannot view users' do
      visit admin_users_path
      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end

  context 'signed in as admin' do
    before { login_as admin }

    it "can view users" do
      visit admin_users_path
      expect(page).to have_content(admin.email)
    end

    it "can view his profile" do
      visit admin_dashboard_path
      within '.navbar' do
        click_link admin.email
      end
      expect(page.current_path).to eq(edit_admin_user_path(admin))
    end

    it "can paginate users" do
      u1 = create(:user)
      u2 = create(:user)
      visit admin_users_path
      expect(page).not_to have_css('.pagination')
      visit admin_users_path(per_page: 1)
      expect(page).to have_css('.pagination')
      expect(page).to have_content(u2.email)
      click_link('Next')
      expect(page).to have_content(u1.email)
      expect(page.current_url).to eq(admin_users_url(page: 2, per_page: 1 ))
    end

    context 'creating a user' do
      it 'fails with invalid attributes' do
        visit new_admin_user_path
        fill_in 'Email', with: ''
        click_button 'Create User'
        expect(page).to have_content("can't be blank")
      end

      it 'succeed with valid attributes' do
        visit new_admin_user_path
        fill_in 'Email', with: 'test@mail.com'
        fill_in 'user_password', with: 'seshook123'
        fill_in 'user_password_confirmation', with: 'seshook123'
        attach_file('file', 'spec/fixtures/exif.jpg')
        click_button 'Create User'
        expect(page).to have_content("User was successfully created")
      end
    end

    context 'working with a user' do
      it 'cannot edit a user to be invalid' do
        visit edit_admin_user_path(user)
        fill_in 'Email', with: ''
        click_button 'Update User'
        expect(page).to have_content("can't be blank")
      end

      it 'editing a user' do
        visit edit_admin_user_path(user)
        fill_in 'Email', with: 'new@mail.com'
        click_button 'Update User'
        expect(page).to have_content("User was successfully updated")
      end

      it 'deleting a user' do
        visit admin_users_path
        click_link('delete', match: :first)
        expect(page).to have_content('User was successfully destroyed')
      end

      it 'can update avatar image', js: true do
        visit edit_admin_user_path(user)
        attach_file('file', 'spec/fixtures/logo.png')
        expect(page).to have_selector('.s3r-progress')
        expect(page).to have_content('logo.png')
      end

      it 'can remove avatar' do
        user = create(:user_with_avatar)
        visit edit_admin_user_path(user)
        check('user_remove_avatar')
        click_button 'Update User'
        expect(page).to have_content("User was successfully updated")
      end
    end

    context 'searching for users' do
      it 'can search by email' do
        u = create(:user, email: 'searchme@email.com')
        search_with_term('user', 'searchme')
        expect(page).to have_content(u.email)
        expect(page).not_to have_content(user.email)
      end
    end
  end
end
