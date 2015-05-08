module Admin
  class BaseController < ApplicationController
    self.responder = ApplicationResponder
    respond_to :html

    before_filter :require_admin!

    private

    def require_admin!
      authenticate_user!
      unless current_user.admin? || current_user.superadmin?
        sign_out(current_user)
        redirect_to new_admin_session_path, alert: t('errors.access_denied')
      end
    end
  end
end
