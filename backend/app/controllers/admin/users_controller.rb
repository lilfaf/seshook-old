module Admin
  class UsersController < Admin::BaseController
    before_action :set_user, only: [:edit, :update, :destroy]

    def index
      @users = User.page(params[:page]).per(params[:per_page])
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
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
