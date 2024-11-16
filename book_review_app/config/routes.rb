Rails.application.routes.draw do
  # Users routes
  resources :users, only: [:new, :create, :show, :edit, :update]
  get "/signup", to: "users#new"

  # Books routes with nested reviews
  resources :books, only: [:show, :index] do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy] # Adjust actions as needed
  end

  # Session routes for log in and log out
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "static_pages#home"
end
