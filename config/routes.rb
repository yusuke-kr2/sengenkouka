Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  authenticated :user do
    root "declarations#index", as: :authenticated_root
  end
  root "pages#landing"

  resource :profile, only: [ :show, :edit, :update ]
  resources :users, only: [ :show ] do
    member do
      get :followings
      get :followers
    end
  end

  resources :relationships, only: [ :create, :destroy ]
  resources :witnesses, only: [ :create, :destroy, :index ]

  resources :declarations, only: [ :index, :create ] do
    member do
      patch :complete
    end
  end

  namespace :admin do
    root "dashboard#index"
    resources :users, only: [ :index, :destroy ]
    resources :declarations, only: [ :index, :destroy ]
  end

  resources :notifications, only: [ :index ]
  get "search" => "searches#index", as: :search
  get "search/suggestions" => "searches#suggestions", as: :search_suggestions

  get "how_to_use" => "pages#how_to_use", as: :how_to_use
  get "privacy_policy" => "pages#privacy_policy", as: :privacy_policy
  get "terms_of_service" => "pages#terms_of_service", as: :terms_of_service
  get "up" => "rails/health#show", as: :rails_health_check
end
