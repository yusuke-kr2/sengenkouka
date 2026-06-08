Rails.application.routes.draw do
  devise_for :users

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
  resources :witnesses, only: [ :create, :destroy ]

  resources :declarations, only: [ :index, :create ] do
    member do
      patch :complete
    end
  end

  get "how_to_use" => "pages#how_to_use", as: :how_to_use
  get "privacy_policy" => "pages#privacy_policy", as: :privacy_policy
  get "terms_of_service" => "pages#terms_of_service", as: :terms_of_service
  get "contact" => "pages#contact", as: :contact
  get "up" => "rails/health#show", as: :rails_health_check
end
