require 'rails_helper'

describe Admin::BaseController do
  it { is_expected.to use_before_filter(:require_admin!) }
end
