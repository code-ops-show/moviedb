class MoviesController < ApplicationController
  include Refiner::Query
  
  before_filter :beautify_search_url, only: [:index]

  def index
    search  = Movie.custom_search(segment_refiner_query_by("crews", "keyword", "genres"))
    @aggs   = search.response.aggregations.map { |a| AggregationPresenter.new(a) }
    @movies = search.results
  end

private

  def beautify_search_url
    redirect_to search_movies_path(query: "keyword/#{params[:q]}") if params[:q].present?
  end
end
