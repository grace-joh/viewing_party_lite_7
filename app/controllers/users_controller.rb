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
      if user_params[:password] != user_params[:password_confirmation]
        flash[:alert] = "Password confirmation doesn't match Password"
      else
        flash[:alert] = 'Email has already been taken'
      end
      redirect_to '/register'
    end

    # begin
    #   user = User.create!(user_params)
    #   redirect_to user_path(user)
    # rescue ActiveRecord::RecordInvalid => error
    #   flash[:alert] = error.full_message
    #   redirect_to '/register'
    # end
  end

  private
  def user_params
    params.permit(:user_name, :email, :password, :password_confirmation)
  end
end
