class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         def generate_jwt_token
          # Используем секрет из credentials или ENV
          secret_key = Rails.application.credentials.secret_key_base || ENV['JWT_SECRET_KEY']
          
          # Добавляем полезные данные в токен
          payload = {
            user_id: id,
            exp: 24.hours.from_now.to_i  # Срок жизни токена (24 часа)
          }
          
          JWT.encode(payload, secret_key, 'HS256')
        end


        has_many :orders

        def admin?
          role == 'admin'
        end
end
