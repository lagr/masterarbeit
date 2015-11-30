class UsersController < ApplicationController
  def index
    render json: User.all
  end

  def show
    render json: User.find(params[:id]), include: ['worklist', 'worklist.worklist_items']
  end

  def create
    if @user = User.create
      render json: @user
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: @user, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end
end
