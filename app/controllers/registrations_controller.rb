class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, 
                                :first_name, :last_name, :role)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully' },
        user: {
          id: resource.id,
          email: resource.email,
          first_name: resource.first_name,
          last_name: resource.last_name,
          role: resource.role
        }
      }
    else
      render json: {
        status: { message: "User couldn't be created", 
                 errors: resource.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end
end