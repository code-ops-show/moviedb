class MoviesController < ApplicationController
  def index
    @movies = Movie.search(params[:q]).records
  end
end
