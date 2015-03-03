require 'rails_helper'

describe 'managing oauth applications' do
  context 'not signed in as admin' do
    it 'cannot view oauth applications' do
      visit oauth_applications_path
      expect(page.current_url).to eq(new_admin_session_url)
      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end

  context 'signed in as superuser' do
    let(:superadmin) { create(:superadmin) }

    before { login_as superadmin }

    it "can view oauth applications" do
      visit admin_dashboard_path
      click_link 'OAuth Applications'
      expect(page).to have_content('Listing applications')
    end

    it "can paginate albums" do
      a1 = create(:application)
      a2 = create(:application)
      visit oauth_applications_path
      expect(page).not_to have_css('.pagination')
      visit oauth_applications_path(per_page: 1)
      expect(page).to have_css('.pagination')
      expect(page).to have_content(a1.name)
      click_link('Next')
      expect(page).to have_content(a2.name)
      expect(page.current_url).to eq(oauth_applications_url(page: 2, per_page: 1 ))
    end

    context 'creating an oauth application' do
      it 'fails with invalid attributes' do
        visit new_oauth_application_path
        fill_in 'Name', with: ''
        click_button 'Create Application'
        expect(page).to have_content("can't be blank")
      end

      it 'succeed with valid attributes' do
        visit new_oauth_application_path
        fill_in 'Name', with: 'Dummy application'
        fill_in 'Redirect URI', with: 'urn:ietf:wg:oauth:2.0:oob'
        click_button 'Create Application'
        expect(page).to have_content("Application created")
      end
    end

    context 'working with an oauth application' do
      let!(:application) { create(:application) }

      it 'cannot edit an oauth application to be invalid' do
        visit edit_oauth_application_path(application)
        expect(page).to have_content('Editing application')
        fill_in 'Name', with: ''
        click_button 'Update Application'
        expect(page).to have_content("can't be blank")
      end

      it 'editing an oauth application' do
        visit edit_oauth_application_path(application)
        fill_in 'Name', with: 'New app name'
        click_button 'Update Application'
        expect(page.current_path).to eq(oauth_application_path(application))
        expect(page).to have_content("Application updated")
      end

      it 'deleting a spot' do
        visit oauth_applications_path
        click_link 'delete'
        expect(page).to have_content('Application deleted')
      end
    end
  end
end
