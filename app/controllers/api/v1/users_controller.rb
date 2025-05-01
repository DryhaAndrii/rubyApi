module Api
    module V1
      class UsersController < ApplicationController
        before_action :authenticate_user!
        before_action :set_user, only: [:show, :update, :destroy]
        before_action :authorize_admin!, only: [:index, :destroy]
        before_action :authorize_self_or_admin!, only: [:update]
  
        def index
          users = User.all
          render json: users
        end
  
        def show
          render json: @user
        end
  
        def update
          if @user.update(user_params)
            render json: { message: 'User updated successfully', user: @user }
          else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        def destroy
          user = User.with_deleted.find(params[:id]) # чтобы найти и удалённых тоже
          if user.soft_delete
            render json: { status: 200, message: 'User marked as deleted' }
          else
            render json: { status: 422, message: 'Failed to mark user as deleted', errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private
  
        def set_user
          @user = User.find(params[:id])
        end
  
        def authorize_admin!
          puts "CURRENT USER: #{current_user.email}, ROLE: #{current_user.role}"  # Можно убрать после дебага
          unless current_user&.role == 'admin'
            render json: { error: 'Access denied' }, status: :forbidden
          end
        end
  
        def authorize_self_or_admin!
          unless current_user == @user || current_user.role == 'admin'
            render json: { error: 'Access denied' }, status: :forbidden
          end
        end
  
        def user_params
          # Админ может менять всё, пользователь — только свои поля
          if current_user.role == 'admin'
            params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :role)
          else
            params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
          end
        end
      end
    end
  end
  