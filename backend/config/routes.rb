Rails.application.routes.draw do

  devise_for :users, path: ''

  scope :admin do
    as :user do
      get    'login',  to: 'devise/sessions#new',     as: :new_admin_session
    end
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
  end

  root to: 'home#index'
end
