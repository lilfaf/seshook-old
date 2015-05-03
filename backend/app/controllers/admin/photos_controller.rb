module Admin
  class PhotosController < Admin::BaseController
    respond_to :js

    def destroy
      @photo = Photo.find(params[:id])
      @photo.destroy
      respond_with @photo
    end
  end
end