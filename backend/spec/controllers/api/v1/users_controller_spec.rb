require 'rails_helper'

describe Api::V1::UsersController do
  let!(:user) { create(:user) }
  let!(:valid_json) { {user: {email: user.email }}.to_json }

  describe '#index' do
    it 'return spots' do
      create(:user)
      get :index, format: :json
      expect(response.status).to eq(200)
      expect(response.body).to have_json_size(2).at_path('users')
      expect(response.body).to have_json_type(Array).at_path('users')
    end
  end

  describe "#show" do
    it "returns 404 not found" do
      get :show, id: 10, format: :json
      assert_not_found!
    end

    it "return spot" do
      get :show, id: user.id, format: :json
      expect(response.status).to eq(200)
      expect(response.body).to be_json_eql(valid_json)
      expect(response.body).to have_json_type(Hash).at_path('user')
    end
  end
end