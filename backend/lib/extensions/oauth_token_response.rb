module Extensions
  module OAuthTokenResponse
    def body
      super.merge(user_id: token.resource_owner_id).symbolize_keys
    end
  end
end

Doorkeeper::OAuth::TokenResponse.send(:prepend, Extensions::OAuthTokenResponse)

