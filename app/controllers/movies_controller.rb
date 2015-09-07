class MoviesController < ApplicationController
  def index
    @movies = Movie.custom_search((params[:q].present? ? params[:q] : '*')).records
  end
end
