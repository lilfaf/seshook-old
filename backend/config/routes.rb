Rails.application.routes.draw do

  resource :upload, only: [:new, :create]

  use_doorkeeper do
    skip_controllers :applications
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
