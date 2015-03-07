module Admin
  class ApplicationsController < Doorkeeper::ApplicationsController
    layout 'admin'

    authorize_resource class: 'Doorkeeper::Application'

    def index
      @applications = Doorkeeper::Application.page(params[:page]).per(params[:per_page])
    end

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_dashboard_path, alert: exception.message
    end
  end
end
