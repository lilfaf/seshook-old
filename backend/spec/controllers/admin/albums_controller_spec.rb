require 'rails_helper'

describe Admin::AlbumsController do
  let!(:album) { create(:album) }

  before { sign_in current_admin }

  describe "GET index" do
    it "assigns all albums as @albums" do
      get :index
      expect(assigns(:albums)).to eq([album])
    end
  end

  describe "GET new" do
    it "assigns a new album as @album" do
      get :new
      expect(assigns(:album)).to be_a_new(Album)
    end
  end

  describe "GET edit" do
    it "assigns the requested album as @album" do
      get :edit, {id: album.id}
      expect(assigns(:album)).to eq(album)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Album" do
        expect {
          post :create, {album: attributes_for(:album)}
        }.to change(Album, :count).by(1)
      end

      it "assigns a newly created album as @album" do
        post :create, {album: attributes_for(:album)}
        expect(assigns(:album)).to be_a(Album)
        expect(assigns(:album)).to be_persisted
      end

      it "redirects to the created album" do
        post :create, {album: attributes_for(:album)}
        expect(response).to redirect_to admin_albums_url
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved album as @album" do
        post :create, {album: {name: ''}}
        expect(assigns(:album)).to be_a_new(Album)
      end

      it "re-renders the 'new' template" do
        post :create, {album: {name: ''}}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) { {name: 'new name'} }

      it "updates the requested album" do
        put :update, {id: album.id, album: new_attributes}
        album.reload
        expect(album.name).to eq('new name')
      end

      it "assigns the requested album as @album" do
        put :update, {id: album.id, album: new_attributes}
        expect(assigns(:album)).to eq(album)
      end

      it "redirects to the album" do
        put :update, {id: album.id, album: new_attributes}
        expect(response).to redirect_to admin_albums_path
      end
    end

    describe "with invalid params" do
      it "assigns the album as @album" do
        put :update, {id: album.id, album: {name: ''}}
        expect(assigns(:album)).to eq(album)
      end

      it "re-renders the 'edit' template" do
        put :update, {id: album.id, album: {name: ''}}
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    let!(:album) { create(:album_with_photo) }

    it { expect { delete :destroy, {id: album.id} }.to change(Album, :count).by(-1) }
    it { expect { delete :destroy, {id: album.id} }.to change(Photo, :count).by(-1) }

    it "redirects to the albums list" do
      delete :destroy, {id: album.id}
      expect(response).to redirect_to(admin_albums_url)
    end
  end

  context "with spot parent albumable" do
    let(:spot) { create(:spot_with_album) }

    describe "GET index" do
      it "assigns @albumable and associated @albums" do
        get :index, spot_id: spot.id
        expect(assigns(:albumable)).to eq(spot)
        expect(assigns(:albums)).to eq(spot.albums)
      end
    end

    describe "GET new" do
      it "assigns a new @album associated with @albumable" do
        get :new, spot_id: spot.id
        expect(assigns(:album).albumable).to eq(spot)
      end
    end

    describe "GET edit" do
      it "assigns the requested @album from @albumable" do
        get :edit, id: spot.albums.last.id, spot_id: spot.id
        expect(assigns(:album)).to eq(spot.albums.last)
      end
    end

    describe "POST create" do
      it "creates a new Album associated with @albumable" do
        expect {
          post :create, spot_id: spot.id, album: attributes_for(:album)
        }.to change(spot.albums, :count).by(1)
      end
    end

    describe "PUT update" do
      it "updates the @albumable's @album" do
        albumable = spot.albums.last
        put :update, id: albumable.id, spot_id: spot.id, album: {name: 'new name'}
        albumable.reload
        expect(albumable.name).to eq('new name')
      end
    end

    describe "DELETE destroy" do
      it "destroy the @album associated with @albumable" do
        expect {
          delete :destroy, id: spot.albums.last.id, spot_id: spot.id
        }.to change(spot.albums, :count).by(-1)
      end
    end
  end
end
