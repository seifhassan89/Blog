class UsersController < ApplicationController

  before_action :find_user, only: [:show, :update, :destroy]

  
  #GET /users
  def index
    @users = User.joins(:role).all
    mappedUsers = @users.map do |user|
        {
            id: user.id,
            name:user.name,
            phone:user.phone,
            role_id: user.role.id,
            role_name: user.role.name
        }
    end
    sendResponse mappedUsers, true , :ok
  end

  #GET /users/:id
  def show
    mappedUser = {
    id: @user.id,
    name: @user.name,
    phone: @user.phone,
    role_id: @user.role.id,
    role_name: @user.role.name
    }
    sendResponse mappedUser, true , :ok
  end

  #POST /users
  def create
    @user = User.new(user_params_create)
    @user.password = BCrypt::Password.create(@user.password) # encrypt the password
    if @user.save
      sendResponse @user, true , :created
    else
      sendResponse "Unable to create user", false , :unprocessable_entity
    end
  end

  #PUT /users/:id
  def update
    if @user.update(user_params)
      sendResponse @user, true , :ok
    else
      sendResponse "Unable to update user", false , :unprocessable_entity
    end
  end

  #DELETE /users/:id
  def destroy
    @user.destroy
    sendResponse @user, true , :ok
  end

  private

  def find_user
      begin
        @user = User.includes(:role).find(params[:id])
        rescue ActiveRecord::RecordNotFound
          sendResponse  "User not found", false , :not_found
        return
        rescue ArgumentError
          sendResponse  "Invalid User ID", false , :unprocessable_entity
        return
      end
  end

  def user_params
    params.require(:user).permit(:name, :phone, :role_id)
  end

  def user_params_create
    params.require(:user).permit(:name, :phone, :role_id, :password, :email)
  end
end
