class MoviesController < ApplicationController
  def index
    title = params[:search]
    @results = Movie.find_all_by_title(title)
  end
end
