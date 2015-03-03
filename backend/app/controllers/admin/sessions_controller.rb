module Admin
  class SessionsController < Devise::SessionsController
    layout 'devise'
    skip_before_filter :require_admin!
  end
end