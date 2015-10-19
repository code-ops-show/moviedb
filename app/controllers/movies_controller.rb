class MoviesController < ApplicationController
  before_filter :beautify_search_url, only: [:index]

  def index
    search  = Movie.custom_search(segmented_query)
    @aggs   = search.response.aggregations.map { |a| AggregationPresenter.new(a) }
    @movies = search.results
  end

private

  def beautify_search_url
    redirect_to search_movies_path(query: "keyword/#{params[:q]}") if params[:q].present?
  end

  def segmented_query
    query.slice(*["crews", "keyword", "genres"]) rescue {}
  end

  helper_method :segmented_query

  def query
    Hash[*params[:query].split(/\//)] rescue {}
  end

  helper_method :query
end
