require 'rails_helper'

describe Api::V1::SpotsController do
  let!(:spot) { create(:spot, user: current_user) }
  let!(:spot_attributes) { [:id, :latlon, :created_at, :updated_at, :address] }
  let!(:address_attributes) { [:id, :street, :zip, :city, :state, :country] }

  describe '#index' do
    it 'return spots' do
      create(:spot)
      api_get :index
      expect(response.status).to eq(200)
      expect(json_response[:spots].size).to eq(2)
      expect(json_response[:spots].first).to have_attributes(spot_attributes)
    end

    context "pagination" do
      it "can select the next page of products" do
        create(:spot)
        api_get :index, page: 2, per_page: 1
        expect(json_response[:spots].size).to eq(1)

        pagination_meta = json_response[:meta][:pagination]
        expect(pagination_meta[:current_page]).to eq(2)
        expect(pagination_meta[:next_page]).to eq(nil)
        expect(pagination_meta[:prev_page]).to eq(1)
        expect(pagination_meta[:total_pages]).to eq(2)
        expect(pagination_meta[:total_count]).to eq(2)
      end
    end
  end

  describe "#show" do
    it "returns 404 not found" do
      api_get :show, id: 10
      assert_not_found!
    end

    it "return spot" do
      api_get :show, id: spot.id
      expect(response.status).to eq(200)
      expect(json_response[:spot]).to have_attributes(spot_attributes)
      expect(json_response[:spot][:address]).to have_attributes(address_attributes)
      expect(json_response[:spot][:latlon]).to eq([spot.latitude, spot.longitude])
      expect(json_response[:spot][:user]).not_to be_nil
    end
  end

  describe "#create" do
    it "returns 400 bad request" do
      api_post :create
      assert_parameter_missing!
    end

    it "returns 422 unprocessable entity" do
      api_post :create, spot: { name: '' }
      assert_invalid_record!
    end

    it "can create spot" do
      api_post :create, spot: attributes_for(:spot)
      expect(response.status).to eq(200)
      expect(json_response[:spot]).to have_attributes(spot_attributes)
      expect(json_response[:spot][:user][:id]).to eq(current_user.id)
    end
  end

  describe "#update" do
    it "returns 404 not found" do
      api_put :update, id: -1
      assert_not_found!
    end

    it "returns 403 forbidden" do
      spot = create(:spot)
      api_put :update, id: spot.id, spot: { name: '' }
      assert_forbidden_operation!
    end

    it "returns 400 bad request" do
      api_put :update, id: spot.id
      assert_parameter_missing!
    end

    it "returns 422 unprocessable entity" do
      api_put :update, id: spot.id, spot: { latitude: 100 }
      assert_invalid_record!
    end

    it "author can udpate spot" do
      name = 'fosh'
      api_put :update, id: spot.id, spot: { name: name }
      spot.reload
      expect(response.status).to eq(200)
      expect(spot.name).to eq(name)
    end
  end

  describe "#destroy" do
    it "returns 404 not found" do
      api_delete :destroy, id: -1
      assert_not_found!
    end

    it "returns 403 forbidden" do
      spot = create(:spot)
      api_delete :destroy, id: spot.id
      assert_forbidden_operation!
    end

    it "author can delete spot" do
      expect{
        api_delete :destroy, id: spot.id
      }.to change{ Spot.count }.by(-1)
      expect(response.status).to eq(204)
    end
  end
end
