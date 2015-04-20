module Admin
  class UsersController < Admin::BaseController
    before_action :set_user, only: [:edit, :update, :destroy]

    def index
      @q = User.search_with_sort(params[:q])
      @users = @q.result.page(params[:page]).per(params[:per_page])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.create(user_params)
      respond_with :admin, @user
    end

    def update
      @user.update(user_params)
      respond_with :admin, @user
    end

    def destroy
      @user.destroy
      respond_with :admin, @user
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :username, :email,
        :password, :password_confirmation,
        :new_avatar_upload_uuid, :remove_avatar)
    end
  end
end
