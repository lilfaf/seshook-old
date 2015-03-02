require 'constraints/api'

Rails.application.routes.draw do

  mount S3Relay::Engine => '/s3_relay'

  use_doorkeeper do
    skip_controllers :applications
  end

  namespace :api do
    scope module: :v1, constraints: Constraints::Api.new(version: 1, default: true) do
      resources :spots, except: :destroy
    end
  end

  devise_for :users, path: ''

  scope :admin do
    as :user do
      get 'login', to: 'devise/sessions#new', as: :new_admin_session
    end
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :spots, except: :show
  end

  root to: 'home#index'
end
