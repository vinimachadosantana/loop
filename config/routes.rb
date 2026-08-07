Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "/health", to: "health#show"

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :show ]
      resource :registration, only: [ :create ]
      resource :session, only: [ :create, :destroy ]
      resources :organizations, only: [ :index, :create, :show ]
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
