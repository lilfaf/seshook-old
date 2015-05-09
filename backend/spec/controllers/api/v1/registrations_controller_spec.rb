require 'rails_helper'

describe Api::V1::RegistrationsController do
  it { is_expected.not_to use_before_action(:verify_authenticity_token) }
end
