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
        ## TODO extract logic to service and better validations
        #

        ## request access token from verification code
        #
        oauth = Koala::Facebook::OAuth.new(
          ENV['FACEBOOK_APP_ID'],
          ENV['FACEBOOK_APP_SECRET'],
          ENV['FACEBOOK_CALLBACK_URL'] || root_url
        )
        access_token = oauth.get_access_token(user_params[:facebook_auth_code])

        ## request user profile informations
        #
        graph = Koala::Facebook::API.new(access_token)
        profile = graph.get_object('me')

        ## find or create user from facebook hash
        #
        user = User.where(email: profile['email']).first_or_initialize.tap do |u|
            u.facebook_id = profile['id']
            u.username    = profile['name'].gsub(' ', '')
            u.first_name  = profile['first_name']
            u.last_name   = profile['last_name']
            u.gender      = profile['gender']
            u.verified    = profile['verified']
            u.locale      = profile['locale'].split('_').last
            u.birthday    = Date.strptime(profile['birthday'], '%m/%d/%Y')
        end

        if user.save
          ## TODO request avatar url and trigger background processing
          #
          avatar = graph.get_picture(profile['id'], type: :large)

          ## TODO create auth token
          render json: user
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
          :facebook_auth_code
        )
      end
    end
  end
end
