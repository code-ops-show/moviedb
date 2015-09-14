class MoviesController < ApplicationController
  before_filter :beautify_search_url, only: [:index]

  def index
    @movies = Movie.custom_search((params[:query].present? ? params[:query] : '*')).records
  end

private

  def beautify_search_url
    redirect_to search_movies_path(query: params[:q]) if params[:q].present?
  end
end
