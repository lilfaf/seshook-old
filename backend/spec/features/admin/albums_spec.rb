require 'rails_helper'

describe 'managing albums' do
  context 'not signed in as admin' do
    let(:album) { create(:album) }

    it 'cannot view albums' do
      visit admin_albums_path
      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end

  context 'signed in as admin' do
    let(:admin) { create(:admin) }

    before { login_as admin }

    it "can view albums" do
      visit admin_dashboard_path
      within '.navmenu' do
        click_link 'Albums'
      end
      expect(page.current_path).to eq(admin_albums_path)
      expect(page).to have_content('Listing albums')
    end

    it "can paginate albums" do
      a1 = create(:album)
      a2 = create(:album)
      visit admin_albums_path
      expect(page).not_to have_css('.pagination')
      visit admin_albums_path(per_page: 1)
      expect(page).to have_css('.pagination')
      expect(page).to have_content(a1.name)
      click_link('Next')
      expect(page).to have_content(a2.name)
      expect(page.current_url).to eq(admin_albums_url(page: 2, per_page: 1 ))
    end

    it "can visit parent albumable" do
      spot = create(:spot_with_album)
      visit admin_albums_path
      click_link "##{spot.id}"
      expect(page.current_path).to eq(edit_admin_spot_path(spot))
      expect(page).to have_content("Editing spot ##{spot.id}")
    end

    context 'creating a album' do
      it 'fails with invalid attributes' do
        visit new_admin_album_path
        fill_in 'Name', with: ''
        click_button 'Create Album'
        expect(page).to have_content("can't be blank")
      end

      it 'succeed with valid attributes' do
        visit new_admin_album_path
        fill_in 'Name', with: 'default name'
        fill_in 'Description', with: 'some description'
        click_button 'Create Album'
        expect(page).to have_content("Album was successfully created")
      end
    end

    context 'working with a album' do
      let!(:album) { create(:album) }

      it 'cannot edit a album to be invalid' do
        visit edit_admin_album_path(album)
        fill_in 'Name', with: ''
        click_button 'Update Album'
        expect(page).to have_content("can't be blank")
      end

      it 'from index redirects to album edit path' do
        visit admin_albums_path
        click_link album.name
        expect(page.current_path).to eq(edit_admin_album_path(album))
      end

      context 'album with albumable' do
        let!(:spot) { create(:spot_with_album) }

        it 'redirects to spot album edit path' do
          visit admin_albums_path
          click_link spot.albums.last.name
          expect(page.current_path).to eq(edit_polymorphic_path([:admin, spot, spot.albums.last]))
        end
      end

      it 'editing an album' do
        visit edit_admin_album_path(album)
        fill_in 'Name', with: 'new name'
        click_button 'Update Album'
        expect(page).to have_content("Album was successfully updated")
      end

      it 'deleting a album' do
        visit admin_albums_path
        click_link('delete')
        expect(page).to have_content('Album was successfully destroyed')
      end
    end
  end
end
