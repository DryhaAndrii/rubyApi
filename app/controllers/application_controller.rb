class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_user_from_token!, unless: :devise_controller?
  
    protected
  
    # Настройка параметров Devise
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role])
    end
  
    # Аутентификация через JWT токен
    def authenticate_user_from_token!
      authenticate_with_http_token do |token, _options|
        begin
          decoded_token = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' })
          puts "Received token: #{decoded_token}"
          user_id = decoded_token.first['user_id'] || decoded_token.first['sub']
          @current_user = User.find(user_id)
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
          render json: { error: 'Invalid or expired token' }, status: :unauthorized
        end
      end
    end
  
    # Текущий пользователь
    def current_user
      @current_user || super
    end
  
    # Проверка аутентификации
    def authenticate_user!
      head :unauthorized unless current_user
    end
  end