class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.admin?
      stored_location_for(resource) || admin_dashboard_path
    else
      super
    end
  end
end
