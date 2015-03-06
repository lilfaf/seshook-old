require 'rails_helper'

describe 'managing spots' do
  context 'not signed in as admin' do
    let(:user) { create(:user) }

    it 'cannot view spots' do
      visit admin_spots_path
      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end

  context 'signed in as admin' do
    let(:admin) { create(:admin) }

    before { login_as admin }

    it 'can view spots' do
      visit admin_spots_path
      expect(page).to have_content('Listing spots')
    end

    it 'can paginate spots' do
      s1 = create(:spot)
      s2 = create(:spot)
      visit admin_spots_path
      expect(page).not_to have_css('.pagination')
      visit admin_spots_path(per_page: 1)
      expect(page).to have_css('.pagination')
      expect(page).to have_content(s1.name)
      click_link('Next')
      expect(page).to have_content(s2.name)
      expect(page.current_url).to eq(admin_spots_url(page: 2, per_page: 1 ))
    end

    context 'creating a spot' do
      it 'autocomplete form form exif metatdata', js: true do
        visit new_admin_spot_path
        attach_file('spot_photos', 'spec/fixtures/exif.jpg')
        expect(page).to have_field('Photos')
        expect(page).to have_field('Latitude', with: '48.851')
        expect(page).to have_field('Longitude', with: '2.3705')
        expect(page).to have_field('Street', with: 'Rue de Lyon')
        expect(page).to have_field('City', with: 'Paris')
        expect(page).to have_field('Postal code', with: '75012')
        expect(page).to have_field('State', with: 'Ile-de-France')
        expect(page).to have_select('Country', selected: 'France')
      end

      it 'fails with invalid attributes' do
        visit new_admin_spot_path
        fill_in 'Name', with: ''
        click_button 'Create Spot'
        expect(page).to have_content("can't be blank")
      end

      it 'succeed with valid attributes' do
        visit new_admin_spot_path
        fill_in 'Name', with: 'Some name'
        fill_in 'Street', with: 'Dummy address'
        fill_in 'City', with: 'Lyon'
        select('France', from: 'Country', match: :first)
        fill_in 'Latitude', with: '20'
        fill_in 'Longitude', with: '20'
        click_button 'Create Spot'
        expect(page).to have_content('Spot was successfully created')
      end
    end

    context 'working with a spot' do
      let!(:spot) { create(:spot) }

      it 'does not have photos input on edit' do
        visit edit_admin_spot_path(spot)
        expect(page).not_to have_field('Photos')
      end

      it 'cannot edit a spot to be invalid' do
        visit edit_admin_spot_path(spot)
        fill_in 'Street', with: ''
        click_button 'Update Spot'
        expect(page).to have_content("can't be blank")
      end

      it 'editing a spot' do
        visit edit_admin_spot_path(spot)
        fill_in 'Name', with: 'Fosh'
        select('approved', from: 'Status')
        click_button 'Update Spot'
        expect(page.current_path).to eq(admin_spots_path)
        expect(page).to have_content('Spot was successfully updated')
        expect(page).to have_content('Approved')
      end

      it 'deleting a spot' do
        visit admin_spots_path
        click_link 'delete'
        expect(page).to have_content('Spot was successfully destroyed')
      end

      it 'create an associated photo', js: true do
        visit edit_admin_spot_path(spot)
        attach_file('file', 'spec/fixtures/exif.jpg')
        expect(page).to have_selector('.s3r-progress')
        expect(page).to have_content('exif.jpg')
      end

      it 'create an associated album' do
        visit edit_admin_spot_path(spot)
        click_link 'New Album'
        expect(page).to have_content("New album for spot ##{spot.id}")
        expect(page.current_path).to eq(new_polymorphic_path([:admin, spot, Album]))
      end

      it 'editing associated album' do
        spot = create(:spot_with_album)
        visit edit_admin_spot_path(spot)
        click_link 'Edit'
        expect(page.current_path).to eq(edit_polymorphic_path([:admin, spot, spot.albums.last]))
      end
    end
  end
end
