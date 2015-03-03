require 'rails_helper'

describe Admin::SessionsController do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #new' do
    before { get :new }

    it { is_expected.not_to use_before_filter(:require_admin!) }
    it { is_expected.to render_with_layout(:devise) }
  end
end
