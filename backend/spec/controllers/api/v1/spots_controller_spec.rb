require 'rails_helper'

describe Api::V1::SpotsController do
  let!(:spot) { create(:spot) }

  describe '#index' do
    it 'return spots' do
      create(:spot)
      api_get :index
      expect(response.status).to eq(200)
      expect(response.body).to have_json_size(2).at_path('spots')
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
      expect(json_response[:spot][:latlon]).to eq([spot.latitude, spot.longitude])
    end
  end
end
