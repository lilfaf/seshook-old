module Api
  module V1
    class Api::V1::RegistrationsController < Devise::RegistrationsController
      skip_before_filter :verify_authenticity_token
    end
  end
end
