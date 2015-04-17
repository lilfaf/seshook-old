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
        # get user profile info
        graph = Koala::Facebook::API.new(token_info[:access_token])

        profile = graph.get_object('me').symbolize_keys!

        # find or create user from facebook hash
        user = User.from_facebook_auth(profile.merge(token_info))

        if user.persisted?
          access_token = Doorkeeper::AccessToken.create!(
            application_id: nil,
            resource_owner_id: user.id,
            expires_in: 7200
          )

          render json: Doorkeeper::OAuth::TokenResponse.new(access_token).body
        else
          invalid_record!(user)
        end
      end

      private

      # get access token from verification code
      def token_info
        @token_info ||= FB_OAUTH.get_access_token_info(
          user_params[:facebook_auth_code]
        ).symbolize_keys!
      end

      def user_params
        params.require(:user).permit(
          :username, :email,
          :new_avatar_upload_uuid, :remove_avatar,
          :password, :password_confirmation, :current_password,
          :facebook_auth_code
        )
      end
    end
  end
end
