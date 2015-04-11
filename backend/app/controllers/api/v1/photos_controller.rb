module Api
  module V1
    class PhotosController < Api::BaseController
      def destroy
        @photo.destroy
        head :no_content
      end
    end
  end
end
