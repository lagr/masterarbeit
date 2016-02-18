class RolesController < ApplicationController
  before_action :set_role, only: [:show, :update, :destroy, :get_user]

  def index
    @roles = Role.all
    render json: @roles
  end

  def show
    render json: @role
  end

  def get_user
    @user = @role.users.sample
    render json: @user
  end

  def create
    @role = Role.new(role_params)

    if @role.save
      Hutch.publish 'wfms.role.created', role: @role
      render json: @role, status: :created, location: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def update
    @role = Role.find(params[:id])

    if @role.update(role_params)
      Hutch.publish 'wfms.role.updated', role: @role
      head :no_content
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

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
