class MoviesController < ApplicationController
  before_filter :beautify_search_url, only: [:index]

  def index
    search  = Movie.custom_search(query_segment)
    @aggs   = search.response.aggregations.map { |a| AggregationPresenter.new(a) }
    @movies = search.results
  end

private

  def beautify_search_url
    redirect_to search_movies_path(query: "keyword/#{params[:q]}") if params[:q].present?
  end

  def query_segment
    query.slice(*["crews", "keyword"]) rescue {}
  end

  helper_method :query_segment

  def query
    Hash[*params[:query].split(/\//)] rescue {}
  end

  helper_method :query
end
