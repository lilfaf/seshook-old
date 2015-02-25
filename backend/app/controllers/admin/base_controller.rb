class Admin::BaseController < ApplicationController
  before_filter :require_admin!

  private

  def require_admin!
    authenticate_user!
    unless current_user.admin?
      redirect_to root_path, alert: t('error.access_denied')
    end
  end
end
