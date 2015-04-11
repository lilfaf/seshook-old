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

      # {
      #   "id":"10152992380438094",
      #   "birthday":"03/28/1990",
      #   "email":"louis.larpin@gmail.com",
      #   "first_name":"Louis",
      #   "gender":"male",
      #   "last_name":"Larpin",
      #   "link":"https://www.facebook.com/app_scoped_user_id/10152992380438094/",
      #   "locale":"en_US",
      #   "name":"Louis Larpin",
      #   "timezone":2,
      #   "updated_time":"2015-04-08T07:34:48+0000",
      #   "verified":true,
      #   "avatar_url":"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfa1/v/t1.0-1/p200x200/262465_10150275526258094_5306520_n.jpg?oh=db79c6f6f10da3acf38f8f7a02307532\u0026oe=55A19F11\u0026__gda__=1440701285_eb1a01bbf03f074a0622540d1ad234e3"
      # }

      def facebook

        # TODO extract logic to service object

        oauth = Koala::Facebook::OAuth.new(
          ENV['FACEBOOK_APP_ID'],
          ENV['FACEBOOK_APP_SECRET'],
          ENV['FACEBOOK_CALLBACK_URL'] || root_url
        )
        access_token = oauth.get_access_token(user_params[:facebook_auth_code])

        graph = Koala::Facebook::API.new(access_token)
        profile = graph.get_object('me')
        avatar = graph.get_picture(profile['id'], type: :large)

        profile.merge!({avatar_url: avatar})

        # user = User.find_or_create_by(email: profile['email']).tap do |u|
        #     u.facebook_id = profile['id']
        #     u.gender      = profile['gender']
        #     u.first_name  = profile['first_name']
        #     u.last_name   = profile['last_name']
        #     u.save!
        # end

        render json: profile
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
