class SessionsController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    if user && authenticate(user)
      data = {token: generateToken(user)}
      sendResponse data, true , :ok
    else
      sendResponse 'Invalid email or password', false , :unauthorized
    end
  end

  private
  def authenticate(user)
    bcrypt_password = BCrypt::Password.new(user.password)
    bcrypt_password == params[:password]
  end
  def generateToken(user)
    exp = 24.hours.from_now.to_i
    JWT.encode({user_id: user.id, role_id: user.role_id, exp: exp}, Rails.application.config.jwt_secret_key, 'HS256')
  end
end
