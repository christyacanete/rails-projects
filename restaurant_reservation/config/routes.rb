Rails.application.routes.draw do
  # Create routes for admin-related tasks
  namespace :admin do
    get 'dashboard/daily', to: 'dashboard#daily'
    get 'dashboard/weekly', to: 'dashboard#weekly'
    get 'dashboard/monthly', to: 'dashboard#monthly'
    get 'calendar', to: 'dashboard#calendar'
    get 'dashboard', to: 'dashboard#index'
    resources :time_slots, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :reservations, only: [] do
      member do
        get 'contact'
        post 'send_message'
      end
    end
  end

  resources :users, only: [:new, :create]
  resources :reservations, only: [:new, :create, :index, :destroy]

  get 'signup', to: 'users#new', as: 'signup'
  get 'dashboard', to: 'users#dashboard', as: 'user_dashboard'
  get 'logout', to: 'static_pages#logout', as: 'logout_page'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Session routes for Login/Logout
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # Defines the root path route ("/")
  root "static_pages#home"
end
