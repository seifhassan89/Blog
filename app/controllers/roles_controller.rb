class RolesController < ApplicationController

  before_action :find_role, only: [:show, :update, :destroy]
    
  # GET /roles
  def index
    @roles = Role.all
    sendResponse @roles, true , :ok
  end

  # GET /roles/:id
  def show
    sendResponse @role, true , :ok
  end

  # POST /roles
  def create
    @role = Role.new(role_params)
    if @role.save
        sendResponse @role, true , :created
    else
        sendResponse @role, false , :unprocessable_entity
    end
  end

  # PUT /roles/:id
  def update
    if @role.update(role_params)
        sendResponse @role, true , :ok
    else
        sendResponse @role, false , :unprocessable_entity
    end
  end

  # DELETE /roles/:id
  def destroy
    @role.destroy
    sendResponse @role, true , :ok
  end

  private
    def find_role
        begin
            @role = Role.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            sendResponse  "Role not found", false , :not_found
            return
          rescue ArgumentError
            sendResponse  "Invalid Role ID", false , :unprocessable_entity
            return
        end
    end

  def role_params
    params.require(:role).permit(:name)
  end

end
