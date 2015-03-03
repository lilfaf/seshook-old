require 'sidekiq/web'
require 'constraints/api'
require 'constraints/cancan'

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
      get 'login', to: 'admin/sessions#new', as: :new_admin_session
    end
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :spots, except: :show do
      resources :albums, except: :show
    end
    resources :users, except: :show
    resources :albums, except: :show
    resources :applications, as: :oauth_applications
  end

  mount Sidekiq::Web, at: '/sidekiq', constraints: Constraint::CanCan.new(:manage, :sidekiq)

  root to: 'home#index'
end
