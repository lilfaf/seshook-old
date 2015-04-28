require 'rails_helper'

describe Api::V1::AlbumsController do
  let!(:album) { create(:album, user: current_user) }
  let!(:album_attributes) { [:id, :name, :description] }

  context 'pagination' do
    let(:meta) { json_response[:meta] }

    it 'can select the next page' do
      create(:album)
      api_get :index, page: 2, per_page: 1
      expect(json_response[:albums].size).to eq(1)
      expect(meta[:current_page]).to eq(2)
      expect(meta[:next_page]).to eq(nil)
      expect(meta[:prev_page]).to eq(1)
      expect(meta[:total_pages]).to eq(2)
      expect(meta[:total_count]).to eq(2)
    end
  end

  context 'without a scope' do
    describe '#index' do
      it 'returns all albums' do
        create(:spot_with_album)
        api_get :index
        expect(response.status).to eq(200)
        expect(json_response[:albums].size).to eq(2)
        expect(json_response[:albums].first).to have_attributes(album_attributes)
      end
    end

    describe '#show' do
      it 'returns 404 not found' do
        api_get :show, id: 0
        assert_not_found!
      end

      it 'returns album' do
        api_get :show, id: album.id
        expect(response.status).to eq(200)
        expect(json_response[:album]).to have_attributes(album_attributes)
        # TODO test user hash attributes
        expect(json_response[:album][:user]).not_to be_nil
      end
    end

    describe '#create' do
      it 'returns 400 bad request' do
        api_post :create
        assert_parameter_missing!
      end

      it 'returns 422 unprocessable entity' do
        api_post :create, album: { name: '' }
        assert_invalid_record!
      end

      it 'can create spot' do
        api_post :create, album: attributes_for(:album)
        expect(response.status).to eq(200)
        expect(json_response[:album]).to have_attributes(album_attributes)
        expect(json_response[:album][:user][:id]).to eq(current_user.id)
      end
    end

    describe '#update' do
      it 'returns 404 not found' do
        api_put :update, id: -1
        assert_not_found!
      end

      it 'returns 403 forbidden' do
        api_put :update, id: create(:album), album: { name: '' }
        assert_forbidden_operation!
      end

      it 'returns 400 bad request' do
        api_put :update, id: album
        assert_parameter_missing!
      end

      it 'returns 422 unprocessable entity' do
        api_put :update, id: album, album: { name: '' }
        assert_invalid_record!
      end

      it 'author can udpate album' do
        api_put :update, id: album.id, album: { name: 'test' }
        album.reload
        expect(response.status).to eq(200)
        expect(album.name).to eq('test')
      end
    end

    describe '#destroy' do
      it 'returns 404 not found' do
        api_delete :destroy, id: 0
        assert_not_found!
      end

      it 'returns 403 forbidden' do
        api_delete :destroy, id: create(:album)
        assert_forbidden_operation!
      end

      it 'author can delete album' do
        expect{
          api_delete :destroy, id: album
        }.to change{ Album.count }.by(-1)
        expect(response.status).to eq(204)
      end
    end
  end

  context 'with spot parent albumable' do
    let(:spot) { create(:spot_with_album) }

    describe '#index' do
      it 'returns spot albums' do
        api_get :index, spot_id: spot
        expect(response.status).to eq(200)
        expect(json_response[:albums].size).to eq(1)
        expect(json_response[:albums].first).to have_attributes(album_attributes)
      end
    end

    describe '#show' do
      it 'returns spot album' do
        api_get :show, spot_id: spot, id: spot.albums.last
        expect(response.status).to eq(200)
        expect(json_response[:album]).to have_attributes(album_attributes)
      end
    end

    describe '#create' do
      it 'can create album on spot' do
        expect {
          api_post :create, spot_id: spot, album: attributes_for(:album)
        }.to change(spot.albums, :count).by(1)
        expect(response.status).to eq(200)
        expect(json_response[:album]).to have_attributes(album_attributes)
        expect(json_response[:album][:user][:id]).to eq(current_user.id)
      end
    end

    describe '#update' do
      it 'author can udpate album on spot' do
        spot.albums << album
        api_put :update, spot_id: spot, id: album, album: {name: 'new name'}
        album.reload
        expect(album.name).to eq('new name')
      end
    end

    describe 'destroy' do
      it 'author can delete spot albums' do
        spot.albums << album
        expect{
          api_delete :destroy, spot_id: spot, id: album
        }.to change{ spot.albums.count }.by(-1)
        expect(response.status).to eq(204)
      end
    end
  end
end
