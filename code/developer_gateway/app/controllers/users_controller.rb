class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    if params[:role_id].present?
      render json: @users = User.with_role(params[:role_id])
    else
      render json: @users = User.all
    end
  end

  def show
    render json: @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user.update_attributes(user_params)

    if @user.save
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :role_id)
    end
end
