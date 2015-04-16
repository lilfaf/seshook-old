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
        ## request access token from verification code
        #
        token_info = FB_OAUTH.get_access_token_info(user_params[:code])

        ## request user profile informations
        #
        graph = Koala::Facebook::API.new(token_info['access_token'])
        profile = graph.get_object('me')

        ## find or create user from facebook hash
        #
        user = User.from_facebook_auth(profile.merge(token_info))

        ## request avatar url and process
        #
        #unless user.avatar?
        #  user.remote_avatar_url = graph.get_picture(profile['id'], type: :large)
        #end

        if user.persisted?
          ## create seshook access token
          #
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

      def user_params
        params.require(:user).permit(
          :username, :email,
          :new_avatar_upload_uuid, :remove_avatar,
          :password, :password_confirmation, :current_password,
          :code
        )
      end
    end
  end
end
