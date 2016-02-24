class UsersController < ApplicationController
  def index
    @users = mq_request 'user.index', 'user.indexed', {}
    render json: @users
  end

  def show
    @user = mq_request 'user.show', 'user.showed', id: params[:id]
    render json: @user
  end

  def create
    @user = mq_request 'user.create', 'user.created', user: user_params
    render json: @user, status: :created
  end

  def update
    @user = mq_request 'user.update', 'user.updated', user: user_params, id: params[:id]
    render json: @user
  end

  def destroy
    mq_request 'wfms.user.destroy', 'wfms.user.destroyed', id: params[:id]
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :role_id)
  end
end
