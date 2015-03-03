module Admin
  class BaseController < ApplicationController
    layout 'admin'

    self.responder = ApplicationResponder
    respond_to :html

    before_filter :require_admin!

    private

    def require_admin!
      authenticate_user!
      unless current_user.admin? || current_user.superadmin?
        redirect_to root_path, alert: t('errors.access_denied')
      end
    end
  end
end
