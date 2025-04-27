Rails.application.routes.draw do
  # Devise routes for API (JWT)
  devise_for :users, 
           skip: [:sessions, :registrations, :passwords, :confirmations],
           controllers: {
             registrations: 'registrations'
           }

devise_scope :user do
  # Логин
  post '/login', to: 'sessions#create'
  
  # Логаут
  delete '/logout', to: 'sessions#destroy'
  
  # Регистрация
  post '/signup', to: 'registrations#create'
end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

end