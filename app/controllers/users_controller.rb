class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def create
    user = User.new(user_params)

    if user.save
      redirect_to user_path(user)
    else
      flash[:alert] = 'Email has already been taken'

      redirect_to '/register'
    end
  end

  private
  def user_params
    params.permit(:user_name, :email, :password, :password_confirmation)
  end
end
