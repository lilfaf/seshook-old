require 'rails_helper'

describe Admin::PhotosController do
  before { sign_in current_admin }

  describe '#destroy' do
    let!(:photo) { create(:album_with_photo).photos.first }

    it "destroy the photo" do
      expect {
        delete :destroy, id: photo, format: :js
      }.to change(Photo, :count).by(-1)
      expect(response.status).to eq(200)
    end
  end
end
