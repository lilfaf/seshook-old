module Api
  module V1
    class AlbumsController < Api::BaseController
      prepend_before_filter :load_album, only: [:show, :update, :destroy]
      skip_load_resource

      def index
        @albums = scope.accessible_by(current_ability).page(params[:page]).per(params[:per_page])
        render json: @albums, meta: metadata(@albums)
      end

      def show
        render json: @album
      end

      def create
        @album = scope.new(album_params)
        @album.user = current_user
        if @album.save
          render json: @album
        else
          invalid_record!(@album)
        end
      end

      def update
        if @album.update_attributes(album_params)
          render json: @album
        else
          invalid_record!(@album)
        end
      end

      def destroy
        @album.destroy
        head :no_content
      end

      private

      def albumable
        @albumable ||= if params[:spot_id]
                         Spot.find(params[:spot_id])
                       end
      end

      def scope
        albumable ? albumable.albums : Album
      end

      def load_album
        @album = scope.find(params[:id])
      end

      def album_params
        params.require(:album).permit(
          :name, :description, new_photo_uploads_uuids: [])
      end
    end
  end
end
