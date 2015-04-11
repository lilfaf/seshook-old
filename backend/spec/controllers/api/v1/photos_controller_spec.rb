require 'rails_helper'

describe Api::V1::PhotosController do
  describe '#destroy' do
    it 'returns 404 not found' do
      api_delete :destroy, id: -1
      assert_not_found!
    end

    it 'returns 403 forbidden' do
      photo = create(:photo)
      api_delete :destroy, id: photo
      assert_forbidden_operation!
    end

    it 'can delete current user account' do
      photo = create(:photo, user: current_user)
      expect{
        api_delete :destroy, id: photo
      }.to change{ Photo.count }.by(-1)
      expect(response.status).to eq(204)
    end
  end
end
