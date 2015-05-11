require "application_responder"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  respond_to :html, :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.admin? || resource.superadmin?
      stored_location_for(resource) || admin_dashboard_path
    else
      super
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

  def authenticate_for_s3_relay
    doorkeeper_token ? doorkeeper_authorize! : warden.authenticate!
  end
end
