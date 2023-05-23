class UsersController < ApplicationController
  def show
    unless current_user
      redirect_to root_path
      flash[:alert] = 'You must be logged in or registered to access your dashboard'
    end
  end

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to dashboard_path
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
