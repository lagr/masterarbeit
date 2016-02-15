class RolesController < ApplicationController
  before_action :set_role, only: [:show, :update, :destroy, :get_user]

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all

    render json: @roles
  end

  # GET /roles/:id
  # GET /roles/:id.json
  def show
    render json: @role
  end

  # GET /roles/:id
  # GET /roles/:id.json
  def get_user
    @user = @role.users.sample
    render json: @user
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    if @role.save
      Hutch.publish 'wfms.role.created', role: @role
      render json: @role, status: :created, location: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /roles/:id
  # PATCH/PUT /roles/:id.json
  def update
    @role = Role.find(params[:id])

    if @role.update(role_params)
      Hutch.publish 'wfms.role.updated', role: @role
      head :no_content
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /roles/:id
  # DELETE /roles/:id.json
  def destroy
    @role.destroy
    Hutch.publish 'wfms.role.deleted', role: @role

    head :no_content
  end

  private

    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name, :parent_role_id)
    end
end
