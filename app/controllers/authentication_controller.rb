class AuthenticationController < ApplicationController
  before_action :authenticate_request!

  def show
    render json: {user: @current_user}
  end

  private

  def authenticate_request!
    header = request.headers['Authorization']
    if header.present?
      token = header.split(' ').last
      begin
        decoded = JWT.decode(token, Rails.application.config.jwt_secret_key, true, algorithm: 'HS256')
        @current_user = User.find(decoded[0]['user_id'])
      rescue JWT::DecodeError
        render json: {error: 'Invalid token'}, status: :unauthorized
      end
    else
      render json: {error: 'Token not present'}, status: :unauthorized
    end
  end
end