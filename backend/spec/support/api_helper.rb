require 'support/oauth_client_helper'

module ApiHelper
  include OAuthClientHelper

  def current_user
    @current_user ||= create(:user)
  end

  def current_admin
    @current_admin ||= create(:admin)
  end

  def oauth_token
    @token ||= oauth_client.password.get_token(current_user.email, current_user.password).token
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def assert_parameter_missing!
    expect(response.status).to eq(400)
    expect(json_response[:message]).to match(/parameter missing/)
  end

  def assert_forbidden_operation!
    expect(response.status).to eq(403)
    expect(json_response[:message]).to eq('An invalid operation was attempted.')
  end

  def assert_not_found!
    expect(response.status).to eq(404)
    expect(json_response[:message]).to eq('The record you were looking for could not be found.')
  end

  def assert_invalid_record!
    expect(response.status).to eq(422)
    expect(json_response[:message]).to eq('Invalid record. Please fix errors and try again.')
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :controller
end
