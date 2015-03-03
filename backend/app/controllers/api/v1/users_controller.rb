module Api
  module V1
    class UsersController < Api::BaseController
      def index
        render json: User.all
      end

      def show
        render json: User.find(params[:id])
      end
    end
  end
end
