module Api
  module V1
    class SpotsController < Api::BaseController
      skip_load_resource only: [:index, :search]

      def index
        @spots = if params.has_key?(:q)
                   Spot.lookup(params[:q],
                               include: [:address],
                               page: params[:page],
                               per_page: params[:per_page])
                 else
                   Spot.all.page(params[:page]).per(params[:per_page])
                 end
        render json: @spots, meta: metadata(@spots)
      end

      def search
        @spots = Spot.lookup(params[:q], page: params[:page], per_page: params[:per_page])
        render json: @spots, meta: metadata(@spots)
      end

      def show
        render json: @spot
      end

      def create
        @spot.user = current_user
        if @spot.save
          render json: @spot
        else
          invalid_record!(@spot)
        end
      end

      def update
        if @spot.update_attributes(spot_params)
          render json: @spot
        else
          invalid_record!(@spot)
        end
      end

      def destroy
        @spot.destroy
        head :no_content
      end

      private

      def spot_params
        params.require(:spot).permit(
          :name, :latitude, :longitude, new_photo_uploads_uuids: [],
          address_attributes: [:id, :street, :city, :zip, :state, :country_code]
        )
      end
    end
  end
end
