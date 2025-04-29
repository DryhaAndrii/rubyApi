Rails.application.routes.draw do
  # Devise routes for API (JWT)
  devise_for :users, 
           skip: [:sessions, :registrations, :passwords, :confirmations],
           controllers: {
             registrations: 'registrations'
           }

  devise_scope :user do
    post '/login',    to: 'sessions#create'      # Логин
    delete '/logout', to: 'sessions#destroy'     # Логаут
    post '/signup',   to: 'registrations#create' # Регистрация
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # Аутентификация
      get 'validate_token', to: 'auth#validate_token'

      # Товары
      resources :items, only: [:index, :create, :update] do
        collection do
          get :search  # Поиск товаров (GET /api/v1/items/search)
        end
      end

      # Заказы
      resources :orders, only: [:create]
    end
  end
end