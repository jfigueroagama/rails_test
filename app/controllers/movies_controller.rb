class MoviesController < ApplicationController
  def index
    @movies = []
    unless params[:search].nil?
      title = params[:search][:query]
      @movies = Movie.find_all_by_title(title, 10)
    end
  end
  
  def show
    @movie = Movie.find(params[:id])
  end
end
