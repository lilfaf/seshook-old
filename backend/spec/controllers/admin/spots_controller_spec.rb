require 'rails_helper'

describe Admin::SpotsController do
  let(:spot)  { create(:spot) }

  before { sign_in current_admin }

  describe 'GET index' do
    it 'assigns all spots as @spots' do
      get :index
      expect(assigns(:spots)).to eq([spot])
    end
  end

  describe 'GET new' do
    it 'assigns a new spot as @spot' do
      get :new
      expect(assigns(:spot)).to be_a_new(Spot)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested spot as @spot' do
      get :edit, id: spot.id
      expect(assigns(:spot)).to eq(spot)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      let(:valid_attributes) {
        attributes_for(:spot).merge(
          address_attributes: attributes_for(:address)
        )
      }

      it 'creates a new Spot' do
        expect {
          post :create, spot: valid_attributes
        }.to change(Spot, :count).by(1)
      end

      it 'assigns a newly created spot as @spot' do
        post :create, spot: valid_attributes
        expect(assigns(:spot)).to be_a(Spot)
        expect(assigns(:spot)).to be_persisted
      end

      it 'redirects to the created spot' do
        post :create, spot: valid_attributes
        expect(response).to redirect_to admin_spots_url
      end
    end

    describe 'with invalid params' do
      before { post :create, spot: {latitude: ''} }

      it 'assigns a newly created but unsaved spot as @spot' do
        expect(assigns(:spot)).to be_a_new(Spot)
      end

      it 're-renders the new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) { {name: 'dummy'} }

      before { put :update, id: spot.id, spot: new_attributes }

      it 'updates the requested spot' do
        spot.reload
        expect(spot.name).to eq('dummy')
      end

      it 'assigns the requested spot as @spot' do
        expect(assigns(:spot)).to eq(spot)
      end

      it 'redirects to the spot' do
        expect(response).to redirect_to admin_spots_url
      end
    end

    describe 'with invalid params' do
      before { put :update, id: spot.id, spot: {latitude: ''} }

      it 'assigns the spot as @spot' do
        expect(assigns(:spot)).to eq(spot)
      end

      it 're-renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested spot' do
      spot
      expect {
        delete :destroy, id: spot.id
      }.to change(Spot, :count).by(-1)
    end

    it 'redirects to the spots list' do
      delete :destroy, id: spot.id
      expect(response).to redirect_to(admin_spots_url)
    end
  end
end