module Api
  module V1
    class SpotsController < Api::BaseController
      load_and_authorize_resource

      api :GET, '/spots'
      param :page,     Integer, desc: "Page number"
      param :per_page, Integer, desc: "Items per page"

      def index
        @spots = @spots.page(params[:page]).per(params[:per_page])
        render json: @spots, meta: metadata(@spots)
      end

      api :GET, '/spots/:id'
      param :id, Integer, desc: 'Spot ID', required: true

      def show
        render json: @spot
      end

      api :POST, '/spots'
      param :spot, Hash, desc: 'Spot attributes' do
        param :name,     String, desc: 'Spot name'
        param :latitude,  Float,  desc: 'Spot latitude', required: true
        param :longitude, Float,  desc: 'Spot latitude', required: true
        # TODO address
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
          address_attributes: [:street, :city, :zip, :state, :country_code]
        )
      end
    end
  end
end
