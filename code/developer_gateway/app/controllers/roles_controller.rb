class RolesController < ApplicationController
  def index
    @roles = mq_request 'role.index', 'role.indexed', {}
    render json: @roles
  end

  def show
    @role = mq_request 'role.show', 'role.showed', id: params[:id]
    render json: @role
  end

  def create
    @role = mq_request 'role.create', 'role.created', role: role_params
    render json: @role, status: :created
  end

  def update
    @role = mq_request 'role.update', 'role.updated', role: role_params, id: params[:id]
    render json: @role
  end

  def destroy
    mq_request 'wfms.role.destroy', 'wfms.role.destroyed', id: params[:id]
    head :no_content
  end

  private
  def role_params
    params.require(:role).permit(:name, :parent_role_id)
  end
end
