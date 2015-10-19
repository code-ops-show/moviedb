module AggregationsHelper
  AGGREGATION_VALUE = { 
      remove:  -> (query, scope, slug) { (query[scope].split(/,/) - [slug.to_s]).join(',')  },
      merge:   -> (query, scope, slug) { (query[scope] || "").split(/,/).push(slug.to_s).uniq.join(',') },
      replace: -> (query, scope, slug) { slug.to_s }
    }

  def aggregation_path(scope, slug, type)
    merged_query = aggregations type, scope.to_s, slug
    filter_path = merged_query.keys.map { |key| [key, merged_query[key]] }.join('/')
    merged_query.present? ? search_movies_path(filter_path) : posts_path
  end

  def aggregation_active? scope, slug
    (query[scope.to_s] || "").split(/,/).include?(slug.to_s) ? 'active' : nil
  end

  def aggregation_value action, scope, slug
    AGGREGATION_VALUE[aggregation_value_selector(action, scope, slug)].call(query, scope, slug)
  end

  def aggregation_value_selector action, scope, slug
    aggregation_active?(scope, slug).nil? ? action : :remove
  end

  def aggregations action, scope, slug
    merge_values = aggregation_value action, scope, slug
    if merge_values.present?
      query.merge({ scope => merge_values })
    else
      query.delete_if { |k, v| k == scope }
    end
  end
end