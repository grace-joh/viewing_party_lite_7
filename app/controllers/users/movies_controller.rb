class Users::MoviesController < ApplicationController
  # before_action :find_user, only: [:index, :show]

  def index
    if params[:q].empty?
      flash[:alert] = 'Please enter a movie'
      redirect_to discover_index_path
    else
      @movies = MovieListFacade.new(params[:q]).get_movies
    end
  end

  def show
    @facade = MovieFacade.new(params[:id])
  end

  # private

  # def find_user
  #   @user = User.find(params[:user_id])
  # end
end
