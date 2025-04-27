class Api::V1::AuthController < ApplicationController
    before_action :authenticate_user!
  
    def validate_token
      render json: {
        valid: true,
        user: {
          id: current_user.id,
          email: current_user.email,
          first_name: current_user.first_name,
          last_name: current_user.last_name,
          role: current_user.role
        }
      }, status: :ok
    rescue JWT::DecodeError, JWT::ExpiredSignature
      render json: { valid: false }, status: :unauthorized
    end
  end