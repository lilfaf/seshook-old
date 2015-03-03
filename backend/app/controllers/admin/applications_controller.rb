module Admin
  class ApplicationsController < Doorkeeper::ApplicationsController
    layout 'admin'

    authorize_resource class: 'Doorkeeper::Application'

    def index
      @applications = Doorkeeper::Application.page(params[:page]).per(params[:per_page])
    end

    #def create
    #  @application = Doorkeeper::Application.new(application_params)
    #  if @application.save
    #    flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :create])
    #    redirect_to admin_oauth_application_url(@application)
    #  else
    #    render :new
    #  end
    #end

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_dashboard_path, alert: exception.message
    end
  end
end
