module Admin
  class ApplicationsController < Doorkeeper::ApplicationsController
    layout 'admin'
    #helper ApplicationHelper

    #authorize_resource except: [:index, :new]

    #def new
    #  authorize! :create, Doorkeeper::Application
    #  @application = Doorkeeper::Application.new
    #end

    #def index
    #  authorize! :read, Doorkeeper::Application
    #  @applications = Doorkeeper::Application.page(params[:page]).per(params[:per_page])
    #end

    #rescue_from CanCan::AccessDenied do |exception|
    #  redirect_to dashboard_path, alert: exception.message
    #end
  end
end
