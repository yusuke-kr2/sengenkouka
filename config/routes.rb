Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "declarations#index", as: :authenticated_root
  end
  root "pages#landing"

  resource :profile, only: [ :show, :edit, :update ]

  resources :declarations, only: [ :index, :create ] do
    member do
      patch :complete
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
