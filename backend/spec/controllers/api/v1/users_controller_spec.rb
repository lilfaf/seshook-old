require 'rails_helper'

describe Api::V1::UsersController do
  let!(:user) { create(:user) }
  let!(:valid_json) { {user: {email: user.email }}.to_json }

  let!(:attributes) {
    [:id, :username, :email,
      :avatar, :avatar_medium, :avatar_thumb,
      :created_at, :updated_at]
  }

  describe '#index' do
    it 'return spots' do
      api_get :index
      expect(response.status).to eq(200)
      expect(json_response[:users]).to be_a(Array)
      expect(json_response[:users].size).to eq(2)
      expect(json_response[:users].first).to have_attributes(attributes)
    end

    context "pagination" do
      it "can select the next page of products" do
        api_get :index, page: 2, per_page: 1
        expect(json_response[:users].size).to eq(1)

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
      api_get :show, id: -1
      assert_not_found!
    end

    it "return spot" do
      api_get :show, id: user.id
      expect(response.status).to eq(200)
      expect(json_response[:user]).to be_a(Hash)
      expect(json_response[:user]).to have_attributes(attributes)
    end
  end

  describe "#update" do
    it "returns 404 not found" do
      api_put :update, id: -1
      assert_not_found!
    end

    it "returns 403 forbidden" do
      api_put :update, id: user.id, user: { email: '' }
      assert_forbidden_operation!
    end

    it "returns 400 bad request" do
      api_put :update, id: current_user.id
      assert_parameter_missing!
    end

    it "returns 422 unprocessable entity" do
      api_put :update, id: current_user.id, user: { email: '' }
      assert_invalid_record!
    end

    it "can udpate current user account" do
      email = 'new@email.com'
      api_put :update, id: current_user.id, user: { email: email }
      current_user.reload
      expect(response.status).to eq(200)
      expect(current_user.email).to eq(email)
    end
  end

  describe "#destroy" do
    it "returns 404 not found" do
      api_delete :destroy, id: -1
      assert_not_found!
    end

    it "returns 403 forbidden" do
      api_delete :destroy, id: user.id
      assert_forbidden_operation!
    end

    it "can delete current user account" do
      current_user
      expect{
        api_delete :destroy, id: current_user.id
      }.to change{ User.count }.by(-1)
      expect(response.status).to eq(204)
    end
  end
end
