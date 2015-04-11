require 'rails_helper'

describe ApplicationController do
  describe '#configure_permitted_parameters' do
    it 'called on devise controllers' do
      is_expected.to use_before_action(:configure_permitted_parameters)
    end
  end
end