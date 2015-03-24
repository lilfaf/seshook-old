module Api
  module V1
    class SpotsController < Api::BaseController
      load_and_authorize_resource except: [:create, :update]

      def index
        render json: @spots
      end

      def show
        render json: @spot
      end

      def create
        render json: Spot.create(params[:spot])
      end

      def update
        render json: Spot.update(params[:id], params[:spot])
      end

      def destroy
        @spot.destroy
        head :no_content
      end
    end
  end
end
