module Admin
  class AlbumsController < Admin::BaseController
    before_action :set_album, only: [:edit, :update, :destroy]

    def index
      @q = scope.search_with_sort(params[:q])
      @albums = @q.result.includes(:albumable).page(params[:page]).per(params[:per_page])
    end

    def new
      @album = scope.new
    end

    def create
      @album = scope.create(album_params)
      respond_with :admin, @album
    end

    def update
      @album.update(album_params)
      respond_with :admin, @album
    end

    def destroy
      @album.destroy
      respond_with :admin, @album
    end

    private

    def scope
      @albumable = if params[:spot_id]
                     Spot.find(params[:spot_id])
                   end
      @albumable ? @albumable.albums : Album
    end

    def set_album
      @album = scope.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:name, :description, new_photo_uploads_uuids: [])
    end
  end
end
