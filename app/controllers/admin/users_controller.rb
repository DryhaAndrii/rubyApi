class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    def destroy
      user = User.with_deleted.find(params[:id]) # чтобы найти и удалённых тоже
      if user.soft_delete
        render json: { status: 200, message: 'User marked as deleted' }
      else
        render json: { status: 422, message: 'Failed to mark user as deleted', errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

     # GET /admin/users
  def index
    users = User.all
    render json: {
      status: { code: 200, message: 'Users retrieved successfully' },
      data: users.as_json(only: [:id, :email, :first_name, :last_name, :role])
    }
  end
  
    def update
      user = User.find(params[:id])
      
      # Разрешаем менять все параметры, включая роль
      if user.update(user_params)
        render json: { 
          status: { code: 200, message: 'User updated successfully' },
          user: user.as_json(only: [:id, :email, :first_name, :last_name, :role])
        }
      else
        render json: { 
          status: { code: 422, message: "Update failed" },
          errors: user.errors.full_messages 
        }, status: :unprocessable_entity
      end
    end
  
    # Отдельный метод для смены роли
    def change_role
      user = User.find(params[:id])
      
      if user.update(role: params[:role])
        render json: { 
          status: { code: 200, message: 'Role updated successfully' },
          user: { id: user.id, role: user.role }
        }
      else
        render json: { 
          status: { code: 422, message: "Role update failed" },
          errors: user.errors.full_messages 
        }, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
        if admin_password_change?
          params.require(:user).permit(:email, :first_name, :last_name, :role, 
                                     :password, :password_confirmation)
        else
          params.require(:user).permit(:email, :first_name, :last_name, :role)
        end
      end
  
    def authorize_admin!
      unless current_user.admin?
        render json: { 
          error: 'Forbidden: Admin access required' 
        }, status: :forbidden
      end
    end

    private

def admin_password_change?
  current_user.admin? && params[:user][:password].present?
end
  end