class RegistrationsController < Devise::RegistrationsController
  clear_respond_to
  respond_to :json

  def create
    build_resource(sign_up_params)
    
    resource.save
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully' },
        data: { email: resource.email, id: resource.id }
      }
    else
      render json: {
        status: { code: 422, message: "User couldn't be created", 
                errors: resource.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end