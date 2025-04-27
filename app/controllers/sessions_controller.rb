class SessionsController < Devise::SessionsController
    respond_to :json
  
    private
  
    def respond_with(resource, _opts = {})
      render json: {
        status: { code: 200, message: 'Logged in successfully' },
        user: {
    email: resource.email,
    id: resource.id
  },
  token: request.env['warden-jwt_auth.token'] || resource.generate_jwt_token
      }
    end
  
    def respond_to_on_destroy
      render json: {
        status: { code: 200, message: 'Logged out successfully' }
      }
    end
  end