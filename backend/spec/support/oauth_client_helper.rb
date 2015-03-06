require 'oauth2'

module OAuthClientHelper
  def oauth_client
    app = create(:application)
    @client = OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
  end
end
