class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      flash[:alert] = user.errors.full_messages
      redirect_to '/register'
    end

    # ERROR - ActionDispatch::Cookies::CookieOverflow
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
