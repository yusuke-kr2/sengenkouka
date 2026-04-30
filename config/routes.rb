Rails.application.routes.draw do
  root "pages#landing"

  get "up" => "rails/health#show", as: :rails_health_check
end
