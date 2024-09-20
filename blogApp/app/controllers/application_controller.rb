class ApplicationController < ActionController::API
  before_action :authenticate
  
  private
  def authenticate #main autherntication used
    token = request.headers['token']&.split(' ')&.last
    if token
      begin
        decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
        @current_user = User.find(decoded_token.first['user_id'])
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'No token provided' }, status: :unauthorized
    end
  end
end
