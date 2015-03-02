module Api
  module V1
    class SpotsController < Api::BaseController
      def index
        render json: Spot.all
      end

      def show
        render json: Spot.find(params[:id])
      end

      def create
        render json: Spot.create(params[:spot])
      end

      def update
        render json: Spot.update(params[:id], params[:spot])
      end
    end
  end
end
