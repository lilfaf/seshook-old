module Api
  class BaseController < ActionController::Metal
    include AbstractController::Rendering

    include ActionController::UrlFor
    include ActionController::Head
    include ActionController::Rendering
    include ActionController::Renderers::All
    include ActionController::ConditionalGet
    include ActionController::MimeResponds
    include ActionController::ImplicitRender
    include ActionController::RespondWith
    include ActionController::StrongParameters
    include ActionController::Serialization

    include Rails.application.routes.url_helpers

    # Before callbacks should also be executed the earliest as possible, so
    # also include them at the bottom.
    include AbstractController::Callbacks
    include Doorkeeper::Rails::Helpers

    # The same with rescue, append it at the end to wrap as much as possible.
    include ActionController::Rescue

    respond_to :json

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def not_found
      render json: { message: I18n.t('errors.not_found') }, status: :not_found
    end
  end
end
