require "application_responder"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.admin? || resource.superadmin?
      stored_location_for(resource) || admin_dashboard_path
    else
      super
    end
  end

  def authenticate_for_s3_relay
    doorkeeper_token ? doorkeeper_authorize! : warden.authenticate!

    #current_user = if doorkeeper_token
    #         User.find(doorkeeper_token.resource_owner_id)
    #       else
    #         warden.authenticate!
    #       end
  end
end
