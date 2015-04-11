module Api
  module V1
    class UsersController < Api::BaseController
      skip_before_action :doorkeeper_authorize!, only: :facebook
      skip_load_and_authorize_resource only: :facebook

      def index
        @users = @users.page(params[:page]).per(params[:per_page])
        render json: @users, meta: metadata(@users)
      end

      def show
        # TODO restrict json response content
        render json: @user
      end

      def update
        if @user.update_attributes(user_params)
          render json: @user
        else
          invalid_record!(@user)
        end
      end

      def destroy
        @user.destroy
        head :no_content
      end

      def facebook
        render json: user_params
      end

      private

      def user_params
        params.require(:user).permit(
          :email, :new_avatar_upload_uuid, :remove_avatar,
          :password, :password_confirmation, :current_password,
          :facebook_auth_code
        )
      end
    end
  end
end
