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
      resources :spots, except: [:new, :edit] do
        get :search, on: :collection
        resources :albums, except: [:new, :edit]
      end
      resources :users, except: [:new, :edit, :create] do
        post :facebook, on: :collection
      end
      resources :albums, except: [:new, :edit]
      resources :photos, only: [:destroy]
    end
  end

  scope :api do
    as :user do
      post 'users', to: 'devise/registrations#create', module: :devise
    end
  end

  devise_for :users

  scope :admin do
    as :user do
      get 'login', to: 'admin/sessions#new', as: :new_admin_session
      resources :applications, controller: 'admin/applications', as: :oauth_applications
    end
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    get :data, to: 'dashboard#chart_data', as: :dashboard_chart_data
    resources :spots, except: :show do
      resources :albums, except: :show
    end
    resources :users, except: :show
    resources :albums, except: :show
    resources :photos, only: :destroy
  end

  mount Sidekiq::Web, at: '/sidekiq', constraints: Constraint::CanCan.new(:manage, :sidekiq)

  get 'about',   to: 'high_voltage/pages#show', id: 'about'
  get 'contact', to: 'high_voltage/pages#show', id: 'contact'
  get 'privacy', to: 'high_voltage/pages#show', id: 'privacy'
  get 'terms',   to: 'high_voltage/pages#show', id: 'terms'

  root to: 'admin/dashboard#index'
end
